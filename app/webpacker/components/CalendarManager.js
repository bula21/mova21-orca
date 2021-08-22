import React from 'react'
import {compose} from 'react-recompose';
import {
  Menu,
  MenuItem,
  withStyles
} from '@material-ui/core';
import DeleteIcon from '@material-ui/icons/Delete'
import CopyIcon from '@material-ui/icons/FileCopy'
import EditIcon from '@material-ui/icons/Edit'
import FullCalendar from '@fullcalendar/react'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import interactionPlugin from '@fullcalendar/interaction'
import bootstrapPlugin from '@fullcalendar/bootstrap'

import EventEditor from './eventEditor'
import InfoSnackbar from './infoSnackbar'
import ErrorSnackbar from './errorSnackbar'
import LoadingBar from './loadingBar'

import {ActivityExecutionService, Field} from "../services/activity-execution-service"

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

class CalendarManager extends React.Component {
  constructor() {
    super()

    this.state = {
      activityId: 0,                                // activity ID
      activityExecutionService: new ActivityExecutionService(),
      availableLanguages: [],                       // executions can have same or less languages then the activity

      event: null,                                  // working event
      events: [],                                   // fullcalendar source for events
      spots: [],                                    // spots including available fields
      calendarRef: React.createRef(),               // reference to full calendar

      showEditor: false,    // flag to open editor
      loading: true,        // flag to trigger loading icon
      error: null,          // to trigger error banner
      success: null,        // to trigger success banner
      mouseX: null,         // position of context menu
      mouseY: null,         // position of context menu
      clickedEventId: 0     // event id of the right clicked event
    }
  }

  componentDidMount() {
    const {activityId, availableLanguages, spots, defaultAmountParticipants} = this.props

    document.addEventListener('click', (e) => {
      if (e.ctrlKey) {
        // todo define what action should be executed with ctrl key
        console.log('With ctrl, do something...');
      }
    });

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

  handleDateSelect = (selectInfo) => {
    let event = {
      start: selectInfo.start,
      end: selectInfo.end,
      allDay: false
    }

    this.setState({
      showEditor: true,
      event: event
    })
  }

  convertFormEventToFullCalendarEvent = (selectedEvent) => ({
    id: selectedEvent.id,
    start: selectedEvent.start,
    end: selectedEvent.end,
    extendedProps: {
      languages: selectedEvent.languages,
      hasTransport: selectedEvent.hasTransport,
      amountParticipants: selectedEvent.amountParticipants,
      field: selectedEvent.field,
      spot: selectedEvent.spot,
    },
    fixedEvent: selectedEvent.fixedEvent
  });

  writeErrorMessage = (orcaI18nText, err) => {
    let errorMessage = err

    if (Array.isArray(err)) {
      errorMessage = err.join(',')
    }

    this.setState({error: {message: `${orcaI18nText} ${errorMessage}`}})
  }

  handleEventSave = (selectedEvent) => {
    const event = this.convertFormEventToFullCalendarEvent(selectedEvent)
    const API = this.state.calendarRef.current.getApi()

    // if id given, update event otherwise create new one
    if (event.id) {
      this.state.activityExecutionService.update(this.state.activityId, event).then(result => {
        // save extended attributes to event object

        // TODO: avoid mutating the state
        this.state.event.setExtendedProp("languages", result.extendedProps.languages)
        this.state.event.setExtendedProp("spot", result.extendedProps.spot)
        this.state.event.setExtendedProp("field", result.extendedProps.field)
        this.state.event.setExtendedProp("amountParticipants", result.extendedProps.amountParticipants)
        this.state.event.setExtendedProp("hasTransport", result.extendedProps.hasTransport)

        // set base attributes to event object
        this.state.event.setProp("backgroundColor", result.color)
        this.state.event.setDates(result.start)
        this.state.event.setEnd(result.end)
        this.state.event.setProp("fixedEvent", result.fixedEvent)

        this.handlContextMenuClose()
        this.setState({
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

  handleEventCopy() {
    const API = this.state.calendarRef.current.getApi()
    let event = API.getEventById(this.state.clickedEventId)

    if (event) {
      // reset id and provide as template for editor
      event = event.toPlainObject()
      event.id = null

      this.setState({
        showEditor: true,
        event: event
      })
    }
  }

  handleEdit() {
    const API = this.state.calendarRef.current.getApi()
    let event = API.getEventById(this.state.clickedEventId)

    if (event) {
      this.setState({
        showEditor: true,
        event: event
      })
    }
  }

  handleEventRemove() {
    const API = this.state.calendarRef.current.getApi()
    let event = API.getEventById(this.state.clickedEventId)

    if (event) {
      if (window.confirm(Orca.i18n.activityExecutionCalendar.delete.confirm)) {
        this.state.activityExecutionService.delete(this.state.activityId, event.id).then((success) => {
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

  handleEventDrag = (evnt) => {
    if (!evnt.event.extendedProps.fixedEvent) {
      this.state.activityExecutionService.update(this.state.activityId, evnt.event).then(result => {
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

  handleEventResize = (evnt) => {
    if (!evnt.event.extendedProps.fixedEvent) {
      this.state.activityExecutionService.update(this.state.activityId, evnt.event).then(result => {
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
      clickedEventId: 0
    })
  };

  // function to render the event content within the calendar
  renderEventContent(eventInfo) {
    const {classes} = this.props
    const eventDescription = eventInfo.event.extendedProps.field ? eventInfo.event.extendedProps.field.name : eventInfo.event.title;
    return (
      <>
        <div title={`${eventInfo.timeText} - ${eventDescription}`}
             className={classes.eventContent}
             onContextMenu={(evt) => eventInfo.event.extendedProps.fixedEvent ? null : this.handleContextMenuClick(evt, eventInfo.event.id)}
             style={{cursor: 'context-menu'}}
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
                ? {top: this.state.mouseY, left: this.state.mouseX}
                : undefined
            }
          >
            <MenuItem onClick={() => this.handleEdit()}><EditIcon/>Edit</MenuItem>
            <MenuItem onClick={() => this.handleEventCopy()}><CopyIcon/>Copy</MenuItem>
            <MenuItem size="small" onClick={() => this.handleEventRemove()}><DeleteIcon/>Delete</MenuItem>
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

  render() {
    return (
      <div className='calendar-manager'>
        <div className='calendar-manager-main'>
          {this.state.showEditor && (
            /* Show editor based on flag*/
            <EventEditor
              onSave={(selectedEvent) => this.handleEventSave(selectedEvent)}
              onDelete={(eventId) => this.handleEventRemove(eventId)}
              onClose={() => this.handleOnClose()}
              onCopy={(eventId) => this.handleEventCopy(eventId)}
              event={this.state.event}
              events={this.state.events}
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
                center: 'title,deleteExecutions',
                right: 'timeGridWeek,timeGridDay'
              }}
              customButtons={{
                deleteExecutions: {
                  text: 'custom!',
                  click: function () {
                    debugger;
                    alert('clicked the custom button!');
                  }
                }
              }}
              locale={Orca.shortLocale}
              themeSystem='bootstrap'
              allDaySlot={false}                                  // don't allow full day event
              firstDay={6}                                        // set first day of week to saturday 6
              validRange={{start: START_DATE, end: END_DATE}}   // calendar is only available in given period
              initialView='timeGridWeek'
              editable={true}
              selectable={true}
              selectMirror={true}
              dayMaxEvents={false}
              eventContent={(eventContent) => this.renderEventContent(eventContent)}              // custom render function
              eventClick={(elem) => elem.event.extendedProps.fixedEvent ? null : this.handleEdit(elem.event.id)}
              eventResize={this.handleEventResize}
              eventDrop={this.handleEventDrag}
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
