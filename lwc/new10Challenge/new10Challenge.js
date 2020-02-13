import { LightningElement, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getAccountsWithEmptyAddress from "@salesforce/apex/PathfinderController.getAccountsWithEmptyAddress";
import getLastUpdatedAccounts from "@salesforce/apex/PathfinderController.getLastUpdatedAccounts";
import PathfinderPlaceRequest from "@salesforce/apex/PathfinderController.findAddressByAccountName";
import PathfinderGeocodingRequest from "@salesforce/apex/PathfinderController.findFullAddress";
import { refreshApex } from "@salesforce/apex";
import { updateRecord } from "lightning/uiRecordApi";
import Id from "@salesforce/schema/Account.Id";
import accountCity from "@salesforce/schema/Account.BillingCity";
import accountStreet from "@salesforce/schema/Account.BillingStreet";
import accountCountry from "@salesforce/schema/Account.BillingCountry";
import accountAddressNotFound from "@salesforce/schema/Account.Address_Not_Found__c";

export default class AccountListEdit extends LightningElement {
  @track accountCity;
  @track accountStreet;
  @track accountCountry;
  @track AccountsWithEmptyAddress;
  @track LastUpdatedAccounts;
  @track accountCountry;
  @track accountAddressNotFound;

  _wiredResultAccountsWithEmptyAddress;
  _wiredResultLastUpdatedAccounts;

  @wire(getAccountsWithEmptyAddress)
  wiredCallbackAccountsWithEmptyAddress(result) {
    this._wiredResultAccountsWithEmptyAddress = result;
    if (result.data) {
      this.AccountsWithEmptyAddress = result.data;
      this.error = undefined;
    } else if (result.error) {
      this.error = result.error;
      this.AccountsWithEmptyAddress = undefined;
    }
  }

  @wire(getLastUpdatedAccounts)
  wiredCallbackLastUpdatedAccounts(result) {
    this._wiredResultLastUpdatedAccounts = result;
    if (result.data) {
      this.LastUpdatedAccounts = result.data;
      this.error = undefined;
    } else if (result.error) {
      this.error = result.error;
      this.LastUpdatedAccounts = undefined;
    }
  }

  handleClick(event) {
    this.targetName = event.target.value;
    this.targetId = event.currentTarget.name;
    this.findPlaceFromTextCallout(this.targetName);
  }

  updateAccout() {
    this.accountAddressNotFound = false;
    const recordInput = {
      fields: {
        [Id.fieldApiName]: this.targetId,
        [accountCity.fieldApiName]: this.accountCity,
        [accountStreet.fieldApiName]: this.accountStreet,
        [accountCountry.fieldApiName]: this.accountCountry,
        [accountAddressNotFound.fieldApiName]: this.accountAddressNotFound
      }
    };
    updateRecord(recordInput)
      .then(
        resolve => {
          this.thowSuccessToast();
          refreshApex(this._wiredResultAccountsWithEmptyAddress);
          refreshApex(this._wiredResultLastUpdatedAccounts);
          this.clearValues();
        },
        reason => {
          console.log("Reason-->", reason);
        }
      )
      .catch(error => {
        console.log("Error:--->  ", error);
      });
  }

  findPlaceFromTextCallout(targetName) {
    this.throwInfoToast();
    PathfinderPlaceRequest({ accountName: targetName })
      .then(data => {
        let objData = JSON.stringify(data);
        if (data) {
          this.geocodingCallout(objData);
        } else {
          this.updateAccountAddressNotfound();
        }
      })
      .catch(error => {
        window.console.log("error ====> " + JSON.stringify(error));
      });
  }

  geocodingCallout(objData) {
    PathfinderGeocodingRequest({ address: objData })
      .then(addressData => {
        this.accountStreet = addressData.street;
        this.accountCountry = addressData.country;
        this.accountCity = addressData.city;
        if (this.accountStreet && this.accountCountry && this.accountCity) {
          this.updateAccout();
        } else {
          this.updateAccountAddressNotfound();
        }
      })
      .catch(error => {
        window.console.log("error ====> " + JSON.stringify(error));
      });
  }

  updateAccountAddressNotfound() {
    this.accountAddressNotFound = true;
    const recordInput = {
      fields: {
        [Id.fieldApiName]: this.targetId,
        [accountAddressNotFound.fieldApiName]: this.accountAddressNotFound
      }
    };
    updateRecord(recordInput)
      .then(
        resolve => {
          this.throwErrorToast();
          refreshApex(this._wiredResultAccountsWithEmptyAddress);
          refreshApex(this._wiredResultLastUpdatedAccounts);
          this.clearValues();
        },
        reason => {
          console.log("Reason-->", reason);
        }
      )
      .catch(error => {
        console.log("Error:--->  ", error);
      });
  }

  throwErrorToast() {
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Address not found",
        message: "Sorry, we couldn't find the address.",
        variant: "error",
        mode: "sticky"
      })
    );
  }

  throwInfoToast() {
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Search started.",
        duration: "1000",
        message: "Searching the Address...",
        variant: "info"
      })
    );
  }

  thowSuccessToast(){
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Success",
        message: "Address found!",
        variant: "success"
      })
    );
  }
  
  clearValues() {
    this.accountCity = "";
    this.accountStreet = "";
    this.accountCountry = "";
    this.accountAddressNotFound = false;
  }
}
