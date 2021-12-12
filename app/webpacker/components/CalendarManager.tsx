import React from 'react'
import { compose } from 'react-recompose';
import { Menu, MenuItem, StyleRulesCallback, WithStyles, withStyles } from '@material-ui/core';
import DeleteIcon from '@material-ui/icons/Delete'
import CopyIcon from '@material-ui/icons/FileCopy'
import EditIcon from '@material-ui/icons/Edit'
import FullCalendar from '@fullcalendar/react'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import interactionPlugin, { EventResizeDoneArg } from '@fullcalendar/interaction'
import bootstrapPlugin from '@fullcalendar/bootstrap'
import { DateSelectArg, EventApi, EventContentArg, EventDropArg } from '@fullcalendar/common';

import EventEditor, { FlattenedFullcalendarEvent } from './eventEditor'
import InfoSnackbar from './infoSnackbar'
import ErrorSnackbar from './errorSnackbar'
import LoadingBar from './loadingBar'

import { ActivityExecutionService, FullCalendarEvent, isNonFixedEvent, NonFixedFullCalendarEvent, Spot } from "../services/activity-execution-service"
import { Component } from 'react';
import { RefObject } from 'react';
import { ClassNameMap, ClassKeyOfStyles } from '@material-ui/styles';

// define range of calendar view
const START_DATE = new Date(Orca.campStart);
const END_DATE = new Date(Orca.campEnd);
const LOCALE = Orca.locale;

const styles = theme => ({
  eventContent: {
    height: "100%"
  },
  truncatedText: {
    textOverflow: "ellipsis"
  }
})


interface CalendarManagerProps {
  activityId: number;
  availableLanguages: string[];
  spots: Array<Spot>;
  defaultAmountParticipants: number;
  classes: ClassNameMap<ClassKeyOfStyles<typeof styles>>
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



class CalendarManager extends Component<CalendarManagerProps, CalendarManagerState> {
  constructor(props: Readonly<CalendarManagerProps>) {
    super(props)

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

  componentDidMount() {
    const { activityId, availableLanguages, spots, defaultAmountParticipants } = this.props

    // todo: improve error handling
    this.state.activityExecutionService.getAll(this.props.activityId).then((result) => {
      this.setState({
        activityId: activityId,
        availableLanguages: availableLanguages,
        events: result,
        spots: spots,
        defaultAmountParticipants: defaultAmountParticipants,
        loading: false,
      })
    })
  }

  // converts javascript date to readable outut
  convertToReadableTime(datetime) {
    let date = datetime.toLocaleDateString(LOCALE)
    let time = datetime.toLocaleTimeString(LOCALE)

    return [date, time].join(" ")
  }

  handleOnClose() {
    this.handlContextMenuClose()
    this.setState({
      showEditor: false
    })
  }

  handleDateSelect = (selectInfo: DateSelectArg) => {
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

    this.setState({ error: { message: `${orcaI18nText} ${errorMessage}` } })
  }

  handleEventSave = (selectedEvent: FlattenedFullcalendarEvent) => {
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

  handleEventCopy(eventId: string): void {
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

  handleEdit(id: string) {
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

  handleEventRemove(eventId: string): void {
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

  handleEventDrag = (evnt: EventDropArg) => {
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

  handleEventResize = (evnt: EventResizeDoneArg) => {
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

  handleContextMenuClick = (event, clickedEventId) => {
    event.preventDefault();

    this.setState({
      mouseX: event.clientX - 2,
      mouseY: event.clientY - 4,
      clickedEventId: clickedEventId
    });
  };

  handlContextMenuClose = () => {
    this.setState({
      mouseX: null,
      mouseY: null,
      clickedEventId: null
    })
  };

  // function to render the event content within the calendar
  renderEventContent(eventInfo: EventContentArg) {
    const { classes } = this.props
    const eventDescription = eventInfo.event.extendedProps.field ? eventInfo.event.extendedProps.field.name : eventInfo.event.title;
    return (
      <>
        <div title={`${eventInfo.timeText} - ${eventDescription}`}
          className={classes.eventContent}
          onDoubleClick={() => this.handleEdit(eventInfo.event.id)}
          onContextMenu={(evt) => eventInfo.event.extendedProps.fixedEvent ? null : this.handleContextMenuClick(evt, eventInfo.event.id)}
          style={{ cursor: 'context-menu' }}
        >
          {eventInfo.timeText && (
            <>
              <span><b>{eventInfo.timeText} </b></span>
              <p className={classes.truncatedText}>{eventDescription}</p>
            </>
          )}

          <Menu
            keepMounted
            open={this.state.mouseY !== null}
            onClose={() => this.handlContextMenuClose()}
            anchorReference="anchorPosition"
            anchorPosition={
              this.state.mouseY !== null && this.state.mouseX !== null
                ? { top: this.state.mouseY, left: this.state.mouseX }
                : undefined
            }
          >
            <MenuItem onClick={() => this.handleEdit(this.state.clickedEventId)}><EditIcon />Edit</MenuItem>
            <MenuItem onClick={() => this.handleEventCopy(this.state.clickedEventId)}><CopyIcon />Copy</MenuItem>
            <MenuItem onClick={() => this.handleEventRemove(this.state.clickedEventId)}><DeleteIcon />Delete</MenuItem>
          </Menu>
        </div>
      </>
    )
  }

  // render event information within top information div
  renderSumEvent(event) {
    return (
      <li key={event.id}>
        <i>{event.title} - </i>
        <b>
          {event.start && (
            this.convertToReadableTime(event.start)
          )}
        </b>
        -
        <b>
          {event.end && (
            this.convertToReadableTime(event.end)
          )}
        </b>
        {event.extendedProps && (
          <div>
            <i>{event.extendedProps.language_flags} - </i>
            <i>{event.extendedProps.amountParticipants} - </i>
            <i>{event.extendedProps.spot.name}</i>
          </div>
        )}
      </li>
    )
  }

  renderHelperElements() {
    return (
      <div>
        {this.state.error && (
          /* Show error bar based on flag*/
          <ErrorSnackbar
            onClose={() => this.setState({ error: null })}
            message={this.state.error.message}
          />
        )}

        {this.state.loading && (
          /* Show loading based on flag*/
          <LoadingBar />
        )}

        {this.state.success && (
          /* show info bar based on flag*/
          <InfoSnackbar
            onClose={() => this.setState({ success: null })}
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

  render() {
    console.log('rerender');
    return (
      <div className='calendar-manager'>
        <div className='calendar-manager-main'>
          {this.state.showEditor && (
            /* Show editor based on flag*/
            <EventEditor
              onSave={(selectedEvent) => this.handleEventSave(selectedEvent)}
              onDelete={(eventId) => this.handleEventRemove(eventId)}
              onClose={() => this.handleOnClose()}
              onCopy={(eventId) => { this.handleEventCopy(eventId) }}
              event={this.state.event}
              availableLanguages={this.state.availableLanguages}
              spots={this.state.spots}
              defaultAmountParticipants={this.state.defaultAmountParticipants}
            />
          )}

          {/* display fullcalendar */}
          {this.state.calendarRef && (
            <FullCalendar
              ref={this.state.calendarRef}
              plugins={[bootstrapPlugin, dayGridPlugin, timeGridPlugin, interactionPlugin]}
              headerToolbar={{
                left: 'prev,next',
                center: 'title',
                right: 'timeGridWeek,timeGridDay'
              }}
              locale={Orca.shortLocale}
              themeSystem='bootstrap'
              allDaySlot={false}                                  // don't allow full day event
              firstDay={6}                                        // set first day of week to saturday 6
              validRange={{ start: START_DATE, end: END_DATE }}   // calendar is only available in given period
              initialView='timeGridWeek'
              editable={true}
              selectable={true}
              selectMirror={true}
              dayMaxEvents={false}
              eventContent={(eventContent) => this.renderEventContent(eventContent)}              // custom render function
              eventResize={this.handleEventResize}
              eventDrop={this.handleEventDrag}
              eventDragStart={() => this.setState({ success: null, error: null })}
              events={this.state.events}
              select={this.handleDateSelect}
              contentHeight="auto"
            />
          )}
        </div>

        {this.renderHelperElements()}
      </div>
    )
  }
}
export default compose(
  withStyles(styles),
)(CalendarManager);
