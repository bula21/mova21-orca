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
import { DateSelectArg, EventContentArg, EventDropArg } from '@fullcalendar/common';

import InfoSnackbar from './infoSnackbar'
import ErrorSnackbar from './errorSnackbar'
import LoadingBar from './loadingBar'

import { FullCalendarEvent } from "../services/activity-execution-service"
import { Component } from 'react';
import { RefObject } from 'react';
import { ClassNameMap, ClassKeyOfStyles, CSSProperties } from '@material-ui/styles';
import { FlattenedFullcalendarEvent } from './eventEditor';

// define range of calendar view
const START_DATE = new Date(Orca.campStart);
const END_DATE = new Date(Orca.campEnd);

export const styles = theme => ({
  eventContent: {
    height: "100%"
  },
  truncatedText: {
    textOverflow: "ellipsis",
    overflow: "hidden",
    display: "block",
    whiteSpace: 'nowrap'
  } as CSSProperties
})


export interface BaseCalendarManagerProps {
  editable: boolean;
  classes: ClassNameMap<ClassKeyOfStyles<typeof styles>>
}

export interface BaseCalendarManagerState {
  events: FullCalendarEvent[];
  calendarRef: RefObject<FullCalendar>
  loading: boolean;
  error: ErrorSnackbar | null;
  success: string | null;
  mouseX: number | null;
  mouseY: number | null;
  clickedEventId: string | null;
}
export abstract class BaseCalendarManager<TProps extends BaseCalendarManagerProps, TState extends BaseCalendarManagerState> extends Component<TProps, TState> {
  protected abstract fetchData(): Promise<Partial<TState>>;
  protected abstract handleEventDrag: (evnt: EventDropArg) => void;
  protected abstract handleEventResize: (evnt: EventResizeDoneArg) => void;
  protected abstract handleDateSelect: (selectInfo: DateSelectArg) => void;
  protected abstract handleEventSave: (selectedEvent: FlattenedFullcalendarEvent) => void;
  protected abstract handleEdit: (id: string) => void;
  protected abstract handleEventRemove: (eventId: string) => void;
  protected abstract handleEventCopy: (eventId: string) => void;

  protected handleContextMenuClick = (event, clickedEventId) => {
    event.preventDefault();

    this.setState({
      mouseX: event.clientX - 2,
      mouseY: event.clientY - 4,
      clickedEventId: clickedEventId
    });
  }

  protected handlContextMenuClose = () => {
    this.setState({
      mouseX: null,
      mouseY: null,
      clickedEventId: null
    })
  };

  async componentDidMount() {
    const data = await this.fetchData();
    this.setState({
      ...data as any,
      loading: false,
    });
  }

  // function to render the event content within the calendar
  renderEventContent(eventInfo: EventContentArg) {
    const { classes } = this.props;
    const event = eventInfo.event;
    const extendedProps = event.extendedProps;
    const summary = [event.title, extendedProps.spot?.name, extendedProps.field?.name, " Participants ", extendedProps.amountParticipants, ' Language ', extendedProps.languages?.join(", ")].filter(Boolean).join(' - ');

    return (
      <>
        <div title={`${eventInfo.timeText} - ${summary}`}
          className={classes.eventContent}
          onDoubleClick={() => this.props.editable ? this.handleEdit(eventInfo.event.id) : null}
          onContextMenu={(evt) => eventInfo.event.extendedProps.fixedEvent ? null : this.handleContextMenuClick(evt, eventInfo.event.id)}
          style={{ cursor: 'context-menu' }}
        >
          {eventInfo.timeText && (
            <>
              <span><b>{eventInfo.timeText} </b></span>
              <p>
                {event.title && (<span className={classes.truncatedText}>{event.title}</span>)}
                {extendedProps.spot && (<span className={classes.truncatedText}>{extendedProps.spot.name}</span>)}
                {extendedProps.field && (<span className={classes.truncatedText}>{extendedProps.field.name}</span>)}
              </p>
            </>
          )}
          {this.renderContextMenu()}
        </div>
      </>
    )
  }


  protected renderContextMenu() {
    return <Menu
      keepMounted
      open={this.state.mouseY !== null}
      onClose={() => this.handlContextMenuClose()}
      anchorReference="anchorPosition"
      anchorPosition={this.state.mouseY !== null && this.state.mouseX !== null
        ? { top: this.state.mouseY, left: this.state.mouseX }
        : undefined}
    >
      <MenuItem onClick={() => this.handleEdit(this.state.clickedEventId)}><EditIcon />Edit</MenuItem>
      <MenuItem onClick={() => this.handleEventCopy(this.state.clickedEventId)}><CopyIcon />Copy</MenuItem>
      <MenuItem onClick={() => this.handleEventRemove(this.state.clickedEventId)}><DeleteIcon />Delete</MenuItem>
    </Menu>;
  }

  // render event information within top information div

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

  protected renderBeforeCalendar(): JSX.Element {
    return <></>;
  }

  render() {
    return (
      <div className='calendar-manager'>
        <div className='calendar-manager-main'>
          {this.renderBeforeCalendar()}

          {this.state.calendarRef && (
            <FullCalendar
              timeZone='Europe/Zurich'
              ref={this.state.calendarRef}
              plugins={[bootstrapPlugin, dayGridPlugin, timeGridPlugin, interactionPlugin]}
              headerToolbar={{
                left: 'prev,next',
                center: 'title',
                right: 'timeGridWeek,timeGridDay'
              }}
              locale={Orca.shortLocale}
              themeSystem='bootstrap5'
              allDaySlot={false}                                  // don't allow full day event
              firstDay={6}
              // set first day of week to saturday 6
              slotMinTime={'05:00:00'}
              slotMaxTime={'28:00:00'}
              validRange={{ start: START_DATE, end: END_DATE }}   // calendar is only available in given period
              initialView={window.innerWidth > 800 ? 'timeGridWeek' : 'timeGridDay' }
              editable={this.props.editable}
              events={this.state.events}
              selectable={this.props.editable}
              selectMirror={this.props.editable}
              dayMaxEvents={false}
              eventContent={(eventContent) => this.renderEventContent(eventContent)}              // custom render function
              eventResize={this.handleEventResize}
              eventDrop={this.handleEventDrag}
              eventDragStart={() => this.setState({ success: null, error: null })}
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
