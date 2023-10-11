import { LightningElement, track } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import FullCalendar from '@salesforce/resourceUrl/FullCalendar';
import getOppo from '@salesforce/apex/oppoCloseDate.getOppo';
import getSerCont from '@salesforce/apex/serviceContractCalendar.getSerCont';
//import heySfLogo from '@salesforce/resourceUrl/heySfLogo';


export default class CalendarVisualizer extends LightningElement {

    //  @track eventData ;
    @track returnedOppo = []; 
    @track returnedServiceContract = []; 
    @track finalOppo = [];
    @track finalServiceContact = [];
    //SfLogo = heySfLogo;

    renderedCallback() {
        Promise.all([
            loadScript(this, FullCalendar + '/jquery.min.js'),
            loadScript(this, FullCalendar + '/moment.min.js'),
            loadScript(this, FullCalendar + '/fullcalendar.min.js'),
            loadStyle(this, FullCalendar + '/fullcalendar.min.css'),
            // loadStyle(this, FullCalendarJS + '/fullcalendar.print.min.css')
        ])
            .then(() => {
                // Initialise the calendar configuration
                this.getTasks();
            })
            .catch(error => {
                // eslint-disable-next-line no-console
                console.error({
                    message: 'Error occured on FullCalendarJS',
                    error
                });
            })
    }
    initialiseFullCalendarJs() {
        // console.log(window.location.href);
        console.log('In nitial');
        console.log(this.returnedServiceContract.length);
        console.log('In initial');
        var str = window.location.href;
        //console.log(str.left());
        var pos = str.indexOf(".com/");
        var last = pos + 4;
        var tDomain = str.slice(0, last);
        for (var i = 0; i < this.returnedServiceContract.length; i++) {
            this.finalServiceContact.push({
                start: this.returnedServiceContract[i].StartDate,
                end: this.returnedServiceContract[i].EndDate,
                title: this.returnedServiceContract[i].Name,
                url: tDomain + '/lightning/r/ServiceContract/' + this.returnedServiceContract[i].Id + '/view'
            });
        }
        console.log(this.finalServiceContact.length);
        console.log('Final Task Length Above');
        const ele = this.template.querySelector('div.fullcalendarjs');
        // eslint-disable-next-line no-undef
        $(ele).fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,basicWeek,basicDay'
            },
            // defaultDate: '2020-03-12',
            defaultDate: new Date(), // default day is today
            navLinks: true, // can click day/week names to navigate views
            editable: true,
            eventLimit: true, // allow "more" link when too many events
            events: this.finalServiceContact
        });
    }
    getTasks() {
        getSerCont()
            .then(result => {
                console.log(JSON.parse(result));
                this.returnedServiceContract = JSON.parse(result);
                console.log('Object Returned');
                this.initialiseFullCalendarJs();
                this.error = undefined;
            })
            .catch(error => {
                console.log(error);
                console.log('error');
                this.error = error;
                this.outputResult = undefined;
            });
    }


}