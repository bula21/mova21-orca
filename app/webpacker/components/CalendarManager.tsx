import React from 'react'
import { compose } from 'react-recompose';
import { withStyles } from '@material-ui/core';
import FullCalendar from '@fullcalendar/react'
import { EventResizeDoneArg } from '@fullcalendar/interaction'
import { DateSelectArg, EventApi, EventDropArg } from '@fullcalendar/common';

import EventEditor, { FlattenedFullcalendarEvent } from './eventEditor'
import InfoSnackbar from './infoSnackbar'
import ErrorSnackbar from './errorSnackbar'
import LoadingBar from './loadingBar'

import {
  ActivityExecutionService,
  FullCalendarEvent,
  isNonFixedEvent,
  NonFixedFullCalendarEvent,
  Spot
} from "../services/activity-execution-service"
import { RefObject } from 'react';
import { ClassNameMap, ClassKeyOfStyles } from '@material-ui/styles';
import { BaseCalendarManager, styles } from "./BaseCalendarManager";

interface CalendarManagerProps {
  activityId: number;
  availableLanguages: string[];
  spots: Array<Spot>;
  defaultAmountParticipants: number;
  classes: ClassNameMap<ClassKeyOfStyles<typeof styles>>;
  editable: boolean;
}
interface CalendarManagerState {
  activityId: number;
  activityExecutionService: ActivityExecutionService;
  availableLanguages: string[];
  defaultAmountParticipants: number;
  event: Partial<NonFixedFullCalendarEvent>;
  events: FullCalendarEvent[];
  spots: Array<Spot>;
  calendarRef: RefObject<FullCalendar>
  showEditor: boolean;
  loading: boolean;
  error: ErrorSnackbar
  success: string;
  mouseX: number;
  mouseY: number;
  clickedEventId: string | null;
}

class CalendarManager extends BaseCalendarManager<CalendarManagerProps, CalendarManagerState> {
  constructor(props: Readonly<CalendarManagerProps>) {
    super(props);
    console.log(this.props);

    this.state = {
      activityId: 0,                                // activity ID
      activityExecutionService: new ActivityExecutionService(),
      availableLanguages: [],                       // executions can have same or less languages then the activity
      event: null,                                  // working event
      events: [],                                   // fullcalendar source for events
      spots: [],                                    // spots including available fields
      calendarRef: React.createRef(),               // reference to full calendar
      defaultAmountParticipants: 0,
      showEditor: false,    // flag to open editor
      loading: true,        // flag to trigger loading icon
      error: null,          // to trigger error banner
      success: null,        // to trigger success banner
      mouseX: null,         // position of context menu
      mouseY: null,         // position of context menu
      clickedEventId: null     // event id of the right clicked event
    }
  }

  protected async fetchData(): Promise<Partial<CalendarManagerState>> {
    const {activityId, availableLanguages, spots, defaultAmountParticipants} = this.props

    return this.state.activityExecutionService.getAll(this.props.activityId).then((result) => {
      return ({
        events: result,
        activityId: activityId,
        availableLanguages: availableLanguages,
        spots: spots,
        defaultAmountParticipants: defaultAmountParticipants,
      })
    }
    );
  }

  protected handleDateSelect = (selectInfo: DateSelectArg): void => {
    let event: Partial<NonFixedFullCalendarEvent> = {
      start: selectInfo.start,
      end: selectInfo.end,
      allDay: false
    }

    this.setState({
      showEditor: true,
      event: event
    })
  }

  protected handleEdit = (id: string): void => {
    const API = this.state.calendarRef.current.getApi()
    let event = API.getEventById(id)

    const fullCalendarEvent = this.convertEventApiToNonFixedFullCalendarEvent(event);
    if (event && isNonFixedEvent(fullCalendarEvent)) {
      this.setState({
        showEditor: true,
        event: fullCalendarEvent
      })
    }
  }

  protected handleEventCopy = (eventId: string): void => {
    const API = this.state.calendarRef.current.getApi()
    let event = API.getEventById(eventId)
    const fullCalendarEvent = this.convertEventApiToNonFixedFullCalendarEvent(event);

    if (event && isNonFixedEvent(fullCalendarEvent)) {
      // reset id and provide as template for editor
      fullCalendarEvent.id = null;

      this.setState({
        showEditor: true,
        event: fullCalendarEvent
      })
    }
  }

  protected handleEventRemove = (eventId: string): void => {
    const API = this.state.calendarRef.current.getApi()
    let event = API.getEventById(eventId)

    if (event) {
      if (window.confirm(Orca.i18n.activityExecutionCalendar.delete.confirm)) {
        this.state.activityExecutionService.delete(this.state.activityId, parseInt(event.id, 10)).then((success) => {
          if (success) {
            event.remove()

            this.handlContextMenuClose()
            this.setState({
              showEditor: false,
              success: Orca.i18n.activityExecutionCalendar.delete.success
            })
          } else {
            this.handlContextMenuClose()
            this.setState({
              showEditor: false,
              error: Orca.i18n.activityExecutionCalendar.delete.error
            })
          }
        }).catch((err) => {
          this.writeErrorMessage(Orca.i18n.activityExecutionCalendar.delete.error, err.errors || err)
        })
      }
    }
  }

  protected handleEventDrag = (evnt: EventDropArg): void => {
    if (!evnt.event.extendedProps.fixedEvent) {
      this.state.activityExecutionService.update(this.state.activityId, this.convertEventApiToNonFixedFullCalendarEvent(evnt.event)).then(result => {
        this.setState({
          success: Orca.i18n.activityExecutionCalendar.move.success
        })
      }).catch((err) => {
        this.writeErrorMessage(Orca.i18n.activityExecutionCalendar.move.error, err.errors || err)
        evnt.revert();
      });
    } else {
      evnt.revert();
    }
  }

  protected handleEventResize = (evnt: EventResizeDoneArg): void => {
    if (!evnt.event.extendedProps.fixedEvent) {
      this.state.activityExecutionService.update(this.state.activityId, this.convertEventApiToNonFixedFullCalendarEvent(evnt.event)).then(result => {
        this.setState({
          success: Orca.i18n.activityExecutionCalendar.move.success
        })
      }).catch((err) => {
        this.writeErrorMessage(Orca.i18n.activityExecutionCalendar.move.error, err.errors || err)
        evnt.revert();
      })
    } else {
      evnt.revert();
    }
  }

  protected handleEventSave = (selectedEvent: FlattenedFullcalendarEvent): void => {
    const event = this.convertFormEventToFullCalendarEvent(selectedEvent)
    const API = this.state.calendarRef.current.getApi()

    // if id given, update event otherwise create new one
    if (event.id) {
      this.state.activityExecutionService.update(this.state.activityId, event).then(result => {
        // save extended attributes to event object
        const event = API.getEventById(result.id);
        event.setExtendedProp("languages", result.extendedProps.languages)
        event.setExtendedProp("spot", result.extendedProps.spot)
        event.setExtendedProp("field", result.extendedProps.field)
        event.setExtendedProp("amountParticipants", result.extendedProps.amountParticipants)
        event.setExtendedProp("hasTransport", result.extendedProps.hasTransport)
        event.setExtendedProp("mixedLanguages", result.extendedProps.mixedLanguages)

        // set base attributes to event object
        event.setProp("backgroundColor", result.backgroundColor)
        event.setDates(result.start, result.end)
        event.setProp("fixedEvent", result.extendedProps.fixedEvent)

        this.handlContextMenuClose()
        this.setState({
          event: null,
          success: Orca.i18n.activityExecutionCalendar.update.success,
          showEditor: false,
        })
      }).catch((err) => {
        this.writeErrorMessage(Orca.i18n.activityExecutionCalendar.update.error, err.errors || err)
      })
    } else {
      this.state.activityExecutionService.create(this.state.activityId, event).then(result => {
        API.addEvent(result)

        this.handlContextMenuClose()
        this.setState({
          success: Orca.i18n.activityExecutionCalendar.create.success,
          showEditor: false,
        })
      }).catch((err) => {
        this.writeErrorMessage(Orca.i18n.activityExecutionCalendar.create.error, err.errors || err)
      })
    }
  }


  private handleOnClose() {
    this.handlContextMenuClose()
    this.setState({
      showEditor: false
    })
  }

  convertFormEventToFullCalendarEvent = (selectedEvent: FlattenedFullcalendarEvent): NonFixedFullCalendarEvent => ({
    id: selectedEvent.id,
    start: new Date(selectedEvent.start),
    end: new Date(selectedEvent.end),
    allDay: selectedEvent.allDay,
    extendedProps: {
      languages: selectedEvent.languages,
      hasTransport: selectedEvent.hasTransport,
      mixedLanguages: selectedEvent.mixedLanguages,
      amountParticipants: selectedEvent.amountParticipants,
      field: selectedEvent.field,
      spot: selectedEvent.spot,
      fixedEvent: selectedEvent.fixedEvent,
    },
    backgroundColor: selectedEvent.spot.color
  });

  writeErrorMessage = (orcaI18nText, err) => {
    let errorMessage = err

    if (Array.isArray(err)) {
      errorMessage = err.join(',')
    }

    this.setState({error: {message: `${orcaI18nText} ${errorMessage}`}})
  }


  renderHelperElements() {
    return (
      <div>
        {this.state.error && (
          /* Show error bar based on flag*/
          <ErrorSnackbar
            onClose={() => this.setState({error: null})}
            message={this.state.error.message}
          />
        )}

        {this.state.loading && (
          /* Show loading based on flag*/
          <LoadingBar/>
        )}

        {this.state.success && (
          /* show info bar based on flag*/
          <InfoSnackbar
            onClose={() => this.setState({success: null})}
            message={this.state.success}
          />
        )}
      </div>
    )
  }

  private convertEventApiToNonFixedFullCalendarEvent(event: EventApi): FullCalendarEvent {
    return {
      id: event.id,
      start: event.start,
      title: event.title,
      end: event.end,
      allDay: event.allDay,
      extendedProps: {
        languages: event.extendedProps.languages,
        amountParticipants: event.extendedProps.amountParticipants,
        spot: event.extendedProps.spot,
        field: event.extendedProps.field,
        hasTransport: event.extendedProps.hasTransport,
        mixedLanguages: event.extendedProps.mixedLanguages,
        transportIds: event.extendedProps.transportIds,
        fixedEvent: event.extendedProps.fixedEvent,
      },
      backgroundColor: event.extendedProps.spot.color
    }
  }

  protected renderBeforeCalendar() {
    return (this.state.showEditor && (
      /* Show editor based on flag*/
      <EventEditor
        onSave={(selectedEvent) => this.handleEventSave(selectedEvent)}
        onDelete={(eventId) => this.handleEventRemove(eventId)}
        onClose={() => this.handleOnClose()}
        onCopy={(eventId) => {
          this.handleEventCopy(eventId)
        }}
        event={this.state.event}
        availableLanguages={this.state.availableLanguages}
        spots={this.state.spots}
        defaultAmountParticipants={this.state.defaultAmountParticipants}
      />
    ));
  }
}

export default compose(
  withStyles(styles),
)(CalendarManager);
