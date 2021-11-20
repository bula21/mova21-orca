import React, { Component, Fragment } from 'react';
import {
  TextField,
  withStyles,
  Card,
  CardContent,
  CardActions,
  Modal,
  Button,
  InputLabel,
  Select,
  MenuItem,
  FormControl,
  Input,
  Checkbox,
  ListItemText,
  FormHelperText,
  FormControlLabel, Theme, createStyles
} from '@material-ui/core';
import DeleteIcon from '@material-ui/icons/Delete'; // to-do: change icons to fontawesome
import SaveAltIcon from '@material-ui/icons/SaveAlt';
import ClearIcon from '@material-ui/icons/Clear';
import CopyIcon from '@material-ui/icons/FileCopy'
import {compose} from 'react-recompose';
import { Field, FullCalendarEvent, Language, Spot } from "../services/activity-execution-service"
import * as moment from 'moment';
import 'moment-timezone';

const styles = ({ spacing }: Theme) => createStyles({
  modal: {
    display: 'flex',
    outline: 0,
    alignItems: 'center',
    justifyContent: 'center',
  },
  modalCard: {
    width: '100%',
    maxWidth: 600,
    maxHeight: "100%"
  },
  modalCardContent: {
    display: 'flex',
    flexDirection: 'column',
  },
  formControl: {
    marginTop: spacing(1)
  },
  inputField: {
    marginBottom: spacing(2)
  }
});

function convertDateToIso(date) {
  return moment(date).toISOString(true).substring(0, 16)
}

const defaultSpot = { id: undefined, name: '', fields: [], color: '' };
const defaultField = { id: undefined, name: '' };

interface FlattenedFullcalendarEvent {
  id?: number;
  title: string;
  start: string;
  end: string;
  amountParticipants: number;
  languages: Array<Language>;
  spot: Spot;
  hasTransport: boolean;
  transportIds: string;
  mixedLanguages: boolean;
  field: Field;
  allDay: boolean;
  fixedEvent: boolean;
}

interface EventEditorProps {
  event: FullCalendarEvent;
  events: Array<FullCalendarEvent>;
  availableLanguages: Array<Language>;
  spots: Array<Spot>;
  onSave: (event: FlattenedFullcalendarEvent) => void;
  onClose: () => void;
  defaultAmountParticipants: number;
  onCopy: (eventId: number) => void;
  onDelete: (eventId: number) => void;
  classes: any; // TODO
}

interface EventEditorState {
  events: Array<FullCalendarEvent>;
  availableSpots: Array<Spot>;
  selectedEvent: FlattenedFullcalendarEvent;
  availableLanguages: Array<Language>;
  errorText: string;
}

class EventEditor extends Component<EventEditorProps, EventEditorState> {
  constructor(props: EventEditorProps) {
    super(props);

    this.state = {
      events: [],                     // all events
      availableSpots: [],
      /* TODO: Since we are passing a reference of event, this will change already the object, even if we don't
               save. make sure we pass always pass a copy and make the object immutable. */
      selectedEvent: {                         // current working event
        title: "",
        start: "",
        end: "",
        // TODO: handle case if field already selected (update)
        amountParticipants: props.defaultAmountParticipants,
        spot: defaultSpot,
        field: defaultField,
        hasTransport: true,
        mixedLanguages: false,
        languages: [],
        allDay: false,
        fixedEvent: true,
        transportIds: ''
      },
      availableLanguages: [],       // languages available for this activity execution

      errorText: ""                 // error text which will be displayed on the form
    };
  }

  componentDidMount() {
    const {event, events, availableLanguages, spots} = this.props
    let selectedEvent = {
      ...this.state.selectedEvent,
      id: event.id,
      start: convertDateToIso(event.start),
      end: convertDateToIso(event.end),
      allDay: event.allDay,
      ...event.extendedProps,
      languages: event?.extendedProps?.languages || availableLanguages
    };

    this.setState({
      events: events,
      availableSpots: spots,
      selectedEvent: selectedEvent,
      availableLanguages: availableLanguages
    })
  }

  isEventOverlapping(event1, event2) {
    return ((new Date(event1.start) > new Date(event2.start) && new Date(event1.start) < new Date(event2.end)) ||
      (new Date(event1.end) > new Date(event2.start) && new Date(event1.end) < new Date(event2.end)))
  }

  handleChange = evt => {
    const value = evt.target.type === 'checkbox' ? evt.target.checked : evt.target.value;
    let newSelectedEventState = {
      ...this.state.selectedEvent,
      ...this.mutateSelectedEventState(evt.target.name, value)
    };

    // check if the new event has a valid time period given, so that the start is not in front of the end time
    if (new Date(newSelectedEventState.start) > new Date(newSelectedEventState.end)) {
      this.setState({
        errorText: Orca.i18n.activityExecutionCalendar.editor.date_invalid
      })
    } else {
      this.setState({
        selectedEvent: newSelectedEventState,
        errorText: ""
      });
    }
  }

  mutateSelectedEventState(field, value) {
    const newState = {};
    newState[field] = value;
    return {...this.state.selectedEvent, ...newState };
  }

  handleSpotChange = evt => {
    let spotId = evt.target.value

    this.setState({
      selectedEvent: { ...this.mutateSelectedEventState('spot', this.state.availableSpots.find(spot => spot.id === spotId)), field: defaultField }
    });
  }

  handleFieldChange = evt => {
    let fieldId = evt.target.value

    this.setState({
      selectedEvent: this.mutateSelectedEventState('field', this.state.selectedEvent.spot.fields.find(field => field.id === fieldId))
    });
  }

  // function handling submit of form
  handleSubmit = evt => {
    evt.preventDefault();
    const { onSave } = this.props
    let selectedEvent = this.state.selectedEvent

    // trigger parent function passed by props
    onSave(selectedEvent)
  };

  // handling copy of event
  handleCopy = () => {
    // reset
    let event = this.state.selectedEvent
    event.id = null

    this.setState({
      selectedEvent: event
    })
  }

  render() {
    const { classes, onClose, onDelete } = this.props;

    return (
      <Modal
        className={ classes.modal }
        onClose={ onClose }
        open
      >
        <Card className={ classes.modalCard }>
          <form onSubmit={ (evt) => this.handleSubmit(evt) }>
            <CardContent className={ classes.modalCardContent }>
              <h2 id="modal-title">{ this.state.selectedEvent.id === null ? Orca.i18n.activityExecutionCalendar.editor.title_copy : Orca.i18n.activityExecutionCalendar.editor.title_edit }</h2>

              <TextField
                key="inputStartTime"
                name="start"
                label={ Orca.i18n.activityExecutionCalendar.editor.start_time }
                type="datetime-local"
                value={ this.state.selectedEvent.start }
                onChange={ this.handleChange }
                error={ this.state.errorText.length === 0 ? false : true }
                helperText={ this.state.errorText }
                className={ classes.inputField }
              />

              <TextField
                key="inputEndTime"
                name="end"
                label={ Orca.i18n.activityExecutionCalendar.editor.end_time }
                type="datetime-local"
                value={ this.state.selectedEvent.end }
                onChange={ this.handleChange }
                error={ this.state.errorText.length === 0 ? false : true }
                helperText={ this.state.errorText }
                className={ classes.inputField }
              />

              <TextField
                required
                type="number"
                key="inputAmountParticipants"
                name="amountParticipants"
                placeholder="100"
                label={ Orca.i18n.activityExecutionCalendar.editor.amount_participants }
                value={ this.state.selectedEvent.amountParticipants }
                onChange={ this.handleChange }
                className={ classes.inputField }
              />

              <InputLabel required id="labelInputSpot">{Orca.i18n.activityExecutionCalendar.editor.spot}</InputLabel>
              <Select
                labelId="labelInputSpot"
                id="inputspot"
                name="spot"
                value={ this.state.selectedEvent.spot.id }
                onChange={ this.handleSpotChange }
                autoWidth
              >
                {
                  this.state.availableSpots.map((spot, i) => (
                    <MenuItem key={ `spot-${i}`} value={spot.id}><em>{spot.name }</em></MenuItem>
                  ))
                }
              </Select>

              {this.state.selectedEvent.spot.id && (
                <Fragment>
                  <InputLabel required id="labelInputField">{ Orca.i18n.activityExecutionCalendar.editor.field }</InputLabel>
                  <Select
                    labelId="labelInputField"
                    id="inputfield"
                    name="field"
                    onChange={ this.handleFieldChange }
                    value={ this.state.selectedEvent.field.id }
                    autoWidth
                  >
                    {
                      this.state.selectedEvent.spot.fields.map((field, i) => (
                        <MenuItem key={ `field-${ i }` } value={ field.id }><em>{ field.name }</em></MenuItem>
                      ))
                    }
                  </Select>
                </Fragment>
              )}
              <FormHelperText
                id="helpertext-labelInputField"
              >
                {Orca.i18n.activityExecutionCalendar.editor.manage_spot_hint} <a href={Orca.manage_spot_link}>{Orca.i18n.activityExecutionCalendar.editor.manage_spot_link_text}</a>
              </FormHelperText>

              <FormControl className={ classes.formControl }>
                <InputLabel id="labelInputLanguages">{Orca.i18n.activityExecutionCalendar.editor.languages}</InputLabel>
                <Select
                  labelId="labelInputLanguages"
                  id="inputLanguages"
                  name="languages"
                  multiple
                  value={ this.state.selectedEvent.languages }
                  onChange={ this.handleChange }
                  autoWidth
                  input={ <Input/> }
                  renderValue={ (selected: string[]) => selected.join(', ') }
                >
                  {
                    this.state.availableLanguages.map((language, i) => (
                      <MenuItem key={ `lang-${ i }`} value={ language }>
                        <Checkbox checked={ this.state.selectedEvent.languages.indexOf(language) > -1 }/>
                        <ListItemText primary={ language }/>
                      </MenuItem>
                    ))
                  }
                </Select>
              </FormControl>
              <FormHelperText id="helpertext-labelInputField">{Orca.i18n.activityExecutionCalendar.editor.manage_languages_hint}</FormHelperText>

              <FormControlLabel
                className={ classes.formControl }
                control={
                  <Checkbox
                    id="inputHasTransport"
                    name="hasTransport"
                    checked={ this.state.selectedEvent.hasTransport }
                    value={true}
                    onChange={ this.handleChange }
                    color="primary"
                    inputProps={{ 'aria-label': 'secondary checkbox' }}
                  />
                }
                label={Orca.i18n.activityExecutionCalendar.editor.has_transport}
              />
              {
                  this.state.selectedEvent.hasTransport && this.state.selectedEvent.transportIds &&
                  <FormHelperText>Transport-IDs: {this.state.selectedEvent.transportIds}</FormHelperText>
              }

              <FormControlLabel
                className={ classes.formControl }
                control={
                  <Checkbox
                    id="inputMixedLanguages"
                    name="mixedLanguages"
                    checked={ this.state.selectedEvent.mixedLanguages }
                    value={false}
                    onChange={ this.handleChange }
                    color="primary"
                    inputProps={{ 'aria-label': 'secondary checkbox' }}
                  />
                }
                label={Orca.i18n.activityExecutionCalendar.editor.mixed_languages}
              />
            </CardContent>

            <CardActions>
              <Button size="small" color="primary" type="submit"><SaveAltIcon/>{Orca.i18n.activityExecutionCalendar.editor.save}</Button>
              <Button size="small" onClick={ this.handleCopy }><CopyIcon/>{Orca.i18n.activityExecutionCalendar.editor.copy}</Button>
              <Button size="small"
                      onClick={ () => onDelete(this.state.selectedEvent.id) }><DeleteIcon/>{Orca.i18n.activityExecutionCalendar.editor.delete}</Button>
              <Button size="small" onClick={ () => onClose() }><ClearIcon/>{Orca.i18n.activityExecutionCalendar.editor.cancel}</Button>
            </CardActions>
          </form>
        </Card>
      </Modal>
    );
  }
}

export default compose(
  withStyles(styles),
)(EventEditor);
