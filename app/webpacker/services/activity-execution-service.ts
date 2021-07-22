export type Language = 'de' | 'fr' | 'it' | 'en';

export interface Activity {
    id: number;
    name: string;
    languages: Array<Language>;
}

// backend definition of an activity execution
interface ActivityExecutionRequest {
    activity_execution: {
        starts_at: Date;
        ends_at: Date;
        field_id: number;
        amount_participants: number;
        languages: Array<Language>;
        transport: boolean
    }
}

interface ActivityExecution {
    id: number;
    title: string;
    starts_at: Date;
    ends_at: Date;
    spot: Spot;
    field: Field;
    amount_participants: number;
    languages: Array<Language>;
    transport: boolean
}

interface FixedEvent {
    id: number;
    title: string;
    starts_at: Date;
    ends_at: Date;
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
    fields: Array<Field>
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
export interface FullCalendarEvent {
    id: number;
    start: Date;
    end: Date;
    title?: string;
    allDay: boolean;
    editable?: boolean;
    extendedProps?: {
        languages: Array<Language>;
        amountParticipants: number;
        field: Field,
        spot: Spot,
        hasTransport: boolean
    }
    fixedEvent: boolean;
    color: string;
}


export class ActivityExecutionService {
    public getAll(activityId: number): Promise<Array<FullCalendarEvent>> {
        return Promise.all([this.fetchActivityExecutions(activityId), this.fetchFixedEvents()])
            .then(([activityExecutions, fixedEvents]) =>
                [...activityExecutions, ...fixedEvents])
    }

    private fetchActivityExecutions(activityId: number): Promise<Array<FullCalendarEvent>> {
        return fetch(`/activities/${activityId}/activity_executions?locale=${Orca.shortLocale}`, {
            method: 'GET',
            headers: this.getHeaders()
        })
            .then(response => {
                if(response.status === 200) {
                    return response.json()
                }
                else {
                    throw response.statusText
                }
            })
            .then((activityExexutions: Array<ActivityExecution>) =>
                activityExexutions.map(activityExexution => this.convertActivityExecutionToFullCalendarEvent(activityExexution)));
    }

    private fetchFixedEvents(): Promise<Array<FullCalendarEvent>> {
        return fetch('/admin/fixed_events', {
            method: 'GET',
            headers: this.getHeaders()
        })
            .then(response => response.json())
            .then(fixedEvents => fixedEvents.map(fixedEvent => this.convertFixedEventsToFullCalendarEvent(fixedEvent)));
    }

    private convertActivityExecutionToFullCalendarEvent(activityExexution: ActivityExecution): FullCalendarEvent {
        return {
            id: activityExexution.id,
            start: new Date(activityExexution.starts_at),
            end: new Date(activityExexution.ends_at),
            allDay: false,
            extendedProps: {
                languages: activityExexution.languages,
                amountParticipants: activityExexution.amount_participants,
                spot: activityExexution.spot,
                field: activityExexution.field,
                hasTransport: activityExexution.transport
            },
            fixedEvent: false,
            color: activityExexution.spot.color
        };
    }

    private convertFixedEventsToFullCalendarEvent(fixedEvent: FixedEvent): FullCalendarEvent {
        return {
            id: fixedEvent.id,
            title: fixedEvent.title,
            start: new Date(fixedEvent.starts_at),
            allDay: false,
            end: new Date(fixedEvent.ends_at),
            fixedEvent: true,
            color: '#ffeb00'
        };
    }

    public create(activityId: number, fullCalendarEvent: FullCalendarEvent): Promise<FullCalendarEvent> {
        const requestOptions = {
            method: 'POST',
            headers: this.getHeaders(),
            body: this.getActivityExecutionRequestBody(fullCalendarEvent)
        };

        return fetch(`/activities/${activityId}/activity_executions?locale=${Orca.shortLocale}`, requestOptions)
            .then(response => response.json())
            .then((response: BackendResponse<ActivityExecution>) => {
                if (isSuccessfulBackendResponse(response)) {
                    return this.convertActivityExecutionToFullCalendarEvent(response.data);
                } else {
                    throw response.errors;
                }
            });
    }

    private getActivityExecutionRequestBody(fullCalendarEvent: FullCalendarEvent) {
        const request: ActivityExecutionRequest = {
            activity_execution: {
                starts_at: fullCalendarEvent.start,
                ends_at: fullCalendarEvent.end,
                languages: fullCalendarEvent.extendedProps.languages,
                field_id: fullCalendarEvent.extendedProps.field.id,
                amount_participants: fullCalendarEvent.extendedProps.amountParticipants,
                transport: fullCalendarEvent.extendedProps.hasTransport
            }
        };
        return JSON.stringify(request);
    }

    public update(activityId: number, activityExecution: FullCalendarEvent): Promise<FullCalendarEvent> {
        const requestOptions = {
            method: 'PUT',
            headers: this.getHeaders(),
            body: this.getActivityExecutionRequestBody(activityExecution)
        };

        return fetch(`/activities/${activityId}/activity_executions/${activityExecution.id}?locale=${Orca.shortLocale}`, requestOptions)
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

        return fetch(`/activities/${activityId}/activity_executions/${activityExecutionId}?locale=${Orca.shortLocale}`, requestOptions)
            .then(response => response.status === 200)
    }

    private getHeaders(): { [key: string]: string } {
        return {'Content-Type': 'application/json', 'X-CSRF-Token': this.getAuthenticityToken()};
    }

    private getAuthenticityToken(): string {
        return document.querySelector<HTMLMetaElement>('meta[name=csrf-token]').content;
    }
}
