import { compose } from 'react-recompose';
import { Menu, MenuItem, withStyles } from '@material-ui/core';
import ZoomIn from '@material-ui/icons/ZoomIn'


import { ActivityExecution, ActivityExecutionService, FullCalendarEvent } from "../services/activity-execution-service"
import { BaseCalendarManager, BaseCalendarManagerProps, BaseCalendarManagerState, styles } from "./BaseCalendarManager";
import { DateSelectArg, EventDropArg } from "@fullcalendar/common";
import { EventResizeDoneArg } from '@fullcalendar/interaction';
import { FlattenedFullcalendarEvent } from './eventEditor';
import FullCalendar from '@fullcalendar/react';
import React from 'react';
interface ReadOnlyCalendarManagerProps extends BaseCalendarManagerProps {
  events: ActivityExecution[];
  editable: false;
}

interface ReadOnlyCalendarManagerState extends BaseCalendarManagerState {
}

class ReadOnlyCalendarManager extends BaseCalendarManager<ReadOnlyCalendarManagerProps, ReadOnlyCalendarManagerState>  {
  private activityExecutionService: ActivityExecutionService;

  constructor(props: Readonly<ReadOnlyCalendarManagerProps>) {
    super(props);
    this.activityExecutionService = new ActivityExecutionService();
    this.state = {
      events: [] as FullCalendarEvent[],
      calendarRef: React.createRef<FullCalendar>(),
      loading: true,
      error: null,
      success: null,
      mouseX: null,
      mouseY: null,
      clickedEventId: null
    };
  }

  protected async fetchData(): Promise<Partial<ReadOnlyCalendarManagerState>> {
    return await this.activityExecutionService.fetchFixedEvents().then(events => (
      {
        events: [
          ...events,
          ...this.props.events.map(event => this.activityExecutionService.convertActivityExecutionToFullCalendarEvent(event))
        ]
      }));
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
      <MenuItem onClick={() => this.handleOnShow()}><ZoomIn />Show Activity</MenuItem>
    </Menu>;
  }

  private handleOnShow = () => {
    const API = this.state.calendarRef.current.getApi()
    let event = API.getEventById(this.state.clickedEventId);
    const activityId = event.extendedProps?.activity?.id;
    if(activityId) {
      window.open(`/activities/${activityId}`, '_blank');
    }
  }

  protected handleEventDrag: (evnt: EventDropArg) => void;
  protected handleEventResize: (evnt: EventResizeDoneArg) => void;
  protected handleDateSelect: (selectInfo: DateSelectArg) => void;
  protected handleEventSave: (selectedEvent: FlattenedFullcalendarEvent) => void;
  protected handleEdit: (id: string) => void;
  protected handleEventRemove: (eventId: string) => void;
  protected handleEventCopy: (eventId: string) => void;
}
export default compose(
  withStyles(styles),
)(ReadOnlyCalendarManager);
