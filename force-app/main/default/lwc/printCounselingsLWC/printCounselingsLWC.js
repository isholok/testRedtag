import { LightningElement, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation' ;
/*test message */
export default class PrintCounselingsLWC extends NavigationMixin(LightningElement){
    today = new Date();
    @api recordId
    @track start_date;
    @track end_date;
    connectedCallback() {
        this.start_date = (this.start_date) ? this.start_date : this.today.toJSON().slice(0,10);
        this.end_date = (this.end_date) ? this.end_date : this.addDays(this.today,1).toJSON().slice(0,10);
        this.range = this.diff(this.start_date,this.end_date);
    }

    addDays = (sd,days) => {
        const d = new Date(Number(sd));
        d.setDate(sd.getDate() + days);
        return d;
    }

    diff = (sdate,edate) => {
        let diffTime = Math.abs(new Date(edate).getTime() - new Date(sdate).getTime());
        return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    }

    valid_date = (sdate,edate) => {
        return new Date(edate) >= new Date(sdate);
    }

    handleDateChange = (evt) => {
        let field_name = evt.target.name;

        if(field_name === 'startdate')
            this.start_date = evt.target.value; 
        if(field_name === 'enddate')
            this.end_date = evt.target.value; 

        if(this.valid_date(this.start_date,this.end_date) === true){
            this.range = this.diff(this.start_date,this.end_date);
        }else{
            let inputfield = this.template.querySelector("."+field_name);
            inputfield.setCustomValidity('End date must be greater than the Start date'); 
            inputfield.reportValidity();
        }
    }
    clickHandle(){
        this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
            url: '/apex/BirdseyeGroupPrintPage?recordId=' + this.recordId + '&fromDate=' + this.start_date + '&toDate=' + this.end_date
        }
    }).then(generatedUrl => {
        window.open(generatedUrl);
    });     
    }
}
