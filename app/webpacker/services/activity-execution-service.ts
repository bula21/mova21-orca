import { calculateContrastColor } from "../components/CalendarManager";

export type Language = 'de' | 'fr' | 'it' | 'en';

export interface Activity {
    id: number;
    name: string;
    languages: Array<Language>;
}

// backend definition of an activity execution
interface ActivityExecutionRequest {
    activity_execution: {
        starts_at: string;
        ends_at: string;
        field_id: number;
        amount_participants: number;
        languages: Array<Language>;
        transport: boolean;
        mixed_languages: boolean;
        transport_ids: string;
    }
}

export interface ActivityExecution {
    id: number;
    title: string;
    starts_at: string;
    ends_at: string;
    spot: Spot;
    field: Field;
    amount_participants: number;
    languages: Array<Language>;
    transport: boolean;
    mixed_languages: boolean;
    transport_ids: string;
    activity?: Activity
}

interface FixedEvent {
    id: number;
    title: string;
    starts_at: string;
    ends_at: string;
    fixedEvent: true;
}

export interface Field {
    id: number;
    name: string;
}

export interface Spot {
    id: number;
    name: string;
    color: string;
    fields: Array<Field>;
}

interface SuccessfulBackendResponse<T> {
    success: true;
    data: T;
}

interface UnsuccessfulBackendResponse {
    success: false;
    errors: string[];
}

function isSuccessfulBackendResponse<T>(backendResponse: SuccessfulBackendResponse<T> | UnsuccessfulBackendResponse): backendResponse is SuccessfulBackendResponse<T> {
    return (backendResponse as SuccessfulBackendResponse<T>).success
}

export type BackendResponse<T> = SuccessfulBackendResponse<T> | UnsuccessfulBackendResponse;

// fullcalendar definition of an event

interface FixedFullCalendarEvent {
    id: string;
    start: string;
    end: string;
    title: string;
    allDay: boolean;
    editable: boolean;
    extendedProps: {
        fixedEvent: boolean;
    }
    backgroundColor: string;
    textColor: string;
}

export interface NonFixedFullCalendarEvent {
    id: string;
    start: string;
    title?: string;
    end: string;
    allDay: boolean;
    editable?: boolean;
    extendedProps?: {
        fixedEvent: boolean;
        languages?: Array<Language>;
        amountParticipants?: number;
        field?: Field;
        spot?: Spot;
        hasTransport?: boolean;
        mixedLanguages?: boolean;
        transportIds?: string;
        activity?: Activity;
    }
    backgroundColor: string;
    textColor: string;
}

export type FullCalendarEvent = FixedFullCalendarEvent | NonFixedFullCalendarEvent;

export const isNonFixedEvent = (event: FullCalendarEvent): event is NonFixedFullCalendarEvent => event.extendedProps.fixedEvent === false;

export class ActivityExecutionService {
    public getAll(activityId: number): Promise<Array<FullCalendarEvent>> {
        return Promise.all([this.fetchActivityExecutions(activityId), this.fetchFixedEvents()])
            .then(([activityExecutions, fixedEvents]) =>
                [...activityExecutions, ...fixedEvents])
    }

    private fetchActivityExecutions(activityId: number): Promise<Array<FullCalendarEvent>> {
        return fetch(`/activities/${activityId}/activity_executions.json?locale=${Orca.shortLocale}`, {
            method: 'GET',
            headers: this.getHeaders()
        })
            .then(response => {
                if (response.status === 200) {
                    return response.json()
                }
                else {
                    throw response.statusText
                }
            })
            .then((activityExexutions: Array<ActivityExecution>) =>
                activityExexutions.map(activityExexution => this.convertActivityExecutionToFullCalendarEvent(activityExexution)));
    }

    public fetchFixedEvents(stufe = 'all'): Promise<Array<FullCalendarEvent>> {
        return fetch(`/admin/fixed_events?stufe=${stufe}&locale=${Orca.shortLocale}`, {
            method: 'GET',
            headers: this.getHeaders()
        })
            .then(response => response.json())
            .then(fixedEvents => fixedEvents.map(fixedEvent => this.convertFixedEventsToFullCalendarEvent(fixedEvent)));
    }

    public convertActivityExecutionToFullCalendarEvent(activityExexution: ActivityExecution): NonFixedFullCalendarEvent {
        const calendarEvent: NonFixedFullCalendarEvent = {
            id: activityExexution.id.toString(),
            start: activityExexution.starts_at,
            end: activityExexution.ends_at,
            allDay: false,
            extendedProps: {
                languages: activityExexution.languages,
                amountParticipants: activityExexution.amount_participants,
                spot: activityExexution.spot,
                field: activityExexution.field,
                hasTransport: activityExexution.transport,
                mixedLanguages: activityExexution.mixed_languages,
                transportIds: activityExexution.transport_ids,
                fixedEvent: false,
            },
            backgroundColor: activityExexution.spot.color,
            textColor: calculateContrastColor(activityExexution.spot.color)
        };
        if (activityExexution.title) {
            calendarEvent.title = activityExexution.title;
        }
        if (activityExexution.activity) {
            calendarEvent.extendedProps.activity = activityExexution.activity;
        }
        return calendarEvent;
    }

    private convertFixedEventsToFullCalendarEvent(fixedEvent: FixedEvent): FullCalendarEvent {
        return {
            id: fixedEvent.id.toString(),
            title: fixedEvent.title,
            start: fixedEvent.starts_at,
            allDay: false,
            end: fixedEvent.ends_at,
            extendedProps: {
                fixedEvent: true,
            },
            backgroundColor: '#ffeb00',
            textColor: calculateContrastColor('#ffeb00')
        };
    }

    public create(activityId: number, fullCalendarEvent: NonFixedFullCalendarEvent): Promise<NonFixedFullCalendarEvent> {
        const requestOptions = {
            method: 'POST',
            headers: this.getHeaders(),
            body: this.getActivityExecutionRequestBody(fullCalendarEvent)
        };

        return fetch(`/activities/${activityId}/activity_executions.json?locale=${Orca.shortLocale}`, requestOptions)
            .then(response => response.json())
            .then((response: BackendResponse<ActivityExecution>) => {
                if (isSuccessfulBackendResponse(response)) {
                    return this.convertActivityExecutionToFullCalendarEvent(response.data);
                } else {
                    throw response.errors;
                }
            });
    }

    private getActivityExecutionRequestBody(fullCalendarEvent: NonFixedFullCalendarEvent) {
        const request: ActivityExecutionRequest = {
            activity_execution: {
                starts_at: fullCalendarEvent.start,
                ends_at: fullCalendarEvent.end,
                languages: fullCalendarEvent.extendedProps.languages,
                field_id: fullCalendarEvent.extendedProps.field.id,
                amount_participants: fullCalendarEvent.extendedProps.amountParticipants,
                transport: fullCalendarEvent.extendedProps.hasTransport,
                mixed_languages: fullCalendarEvent.extendedProps.mixedLanguages,
                transport_ids: fullCalendarEvent.extendedProps.transportIds
            }
        };
        return JSON.stringify(request);
    }

    public update(activityId: number, activityExecution: NonFixedFullCalendarEvent): Promise<NonFixedFullCalendarEvent> {
        const requestOptions = {
            method: 'PUT',
            headers: this.getHeaders(),
            body: this.getActivityExecutionRequestBody(activityExecution)
        };

        return fetch(`/activities/${activityId}/activity_executions/${activityExecution.id}.json?locale=${Orca.shortLocale}`, requestOptions)
            .then(response => response.json())
            .then((response: BackendResponse<ActivityExecution>) => {
                if (isSuccessfulBackendResponse(response)) {
                    return this.convertActivityExecutionToFullCalendarEvent(response.data);
                } else {
                    throw response.errors;
                }
            });
    }

    public delete(activityId: number, activityExecutionId: number): Promise<boolean> {
        const requestOptions = {
            method: 'DELETE',
            headers: this.getHeaders()
        };

        return fetch(`/activities/${activityId}/activity_executions/${activityExecutionId}.json?locale=${Orca.shortLocale}`, requestOptions)
            .then(response => response.status === 200)
    }

    private getHeaders(): { [key: string]: string } {
        return { 'Content-Type': 'application/json', 'X-CSRF-Token': this.getAuthenticityToken() };
    }

    private getAuthenticityToken(): string {
        return document.querySelector<HTMLMetaElement>('meta[name=csrf-token]').content;
    }
}
