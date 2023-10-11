import { LightningElement, api,track,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import  getAccounts  from '@salesforce/apex/getRecordDataController.getAccounts';
import  getPriceBooks  from '@salesforce/apex/getPriceBookDataController.getPriceBooks';
import insertserCon from '@salesforce/apex/rentAcarController.insertserCon';               
import getUnitPrice from '@salesforce/apex/rentAcarController.getUnitPrice';               
const ACCOUNT_OBJECT = 'Account';
let i=0;
export default class Rentcar extends LightningElement {
    @api recId;

    @track errorMessage='';
    @track UnitPriceMessage='';

    @track serconRecord = {} ;
    @track lineitemRecord = {};
    @track termField = 0;
    @track unitPrice = 0.0;
    @track selectedAccountId = ''; // Track the selected Account Id
    accountOptions = []; // Store the Account dropdown options
    @track selectedPriceBookId = ''; // Track the selected Account Id
    PricebookOptions = []; // Store the Account dropdown options

    handleAccountChange(event) {
        this.selectedAccountId = event.detail.value;
        console.log("wijden selected id : " + this.selectedAccountId);
    }
    handlePriceBookChange(event) {
        this.selectedPriceBookId = event.detail.value;
        console.log("wijden selectedPriceBookId id : " + this.selectedPriceBookId);
        var vehiID = this.recId ; 
         getUnitPrice({
            vehicule: vehiID,
            PriceBookId: this.selectedPriceBookId
        })
            .then(result => {
                // Handle success
                this.errorMessage='';
                console.log('getUnitPrice inside result:', result);
                this.unitPrice = result ;
            })
            .catch(error => {
                // Handle error
                console.error('Error creating Service Contract:', error.body.message);
                this.errorMessage='test' + error.body.message;
            });


    }
    handleContractNameChange(event) {
        this.serconRecord.Name = event.target.value;
    }

    handleStartDateChange(event) {
        this.serconRecord.StartDate = event.target.value;
    }

    handleTermChange(event) {
        this.termField = event.target.value;
    }
 
 

    createServiceContract() {
        this.serconRecord.AccountId = this.selectedAccountId ; 
        console.log("wijden sercon ");
        console.log(this.serconRecord.AccountId);
        console.log("wijden recId " + this.recId); 
        var vehiID = this.recId ; 
        serconRecord = insertserCon({
            serCon: this.serconRecord,
            term: this.termField,
            vehiculeId: vehiID,
            PriceBookId: selectedPriceBookId
        })
            .then(result => {
                // Handle success
                this.errorMessage='';
                console.log('Service Contract created successfully:', result);
                // Reset form fields
                this.resetFields();
            })
            .catch(error => {
                // Handle error
                console.error('Error creating Service Contract:', error.body.message);
                this.errorMessage='test' + error.body.message;
            });

 
    }

    resetFields() {
        this.serconRecord='';
    }


    @wire(getAccounts)
    wiredPicklistValues({ error, data }) {
        if (data) {
            // Map picklist values to options for the Account dropdown
            console.log("wijden  "+ data);
            for(i=0; i<data.length; i++) {
                console.log('id=' + data[i].Id);
                console.log('name =' + data[i].Name);
                this.accountOptions = [...this.accountOptions ,{value: data[i].Id , label: data[i].Name}];                                   
            }
        } else if (error) {
            // Handle error
            console.error('Error fetching picklist values:', error);
        }
        console.log("wijden accountOptions " );
        console.log( this.accountOptions );
    }

    @wire(getPriceBooks)
    wiredPicklistValues({ error, data }) {
        if (data) {
            // Map picklist values to options for the Account dropdown
            console.log("wijden  "+ data);
            for(i=0; i<data.length; i++) {
                console.log('id=' + data[i].Id);
                console.log('name =' + data[i].Name);
                this.PricebookOptions = [...this.PricebookOptions ,{value: data[i].Id , label: data[i].Name}];                                   
            }
        } else if (error) {
            // Handle error
            console.error('Error fetching picklist values:', error);
        }
        console.log("wijden PricebookOptions " );
        console.log( this.PricebookOptions );
    }
}