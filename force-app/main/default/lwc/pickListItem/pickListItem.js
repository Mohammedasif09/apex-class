import { LightningElement, api, track } from 'lwc';

export default class PickListItem extends LightningElement {
    @api label;
    @api valuechange;
    _disabled = false;
    @track pickValue = '';
    @api
    get disabled() {
        return this._disabled;
    }
    set disabled(value) {
        this._disabled = value;
        this.handleDisabled();
    }
    @track inputOptions;
    @api
    get options() {
        return this.inputOptions;
    }
    set options(value) {
        let options = [];
        this.inputOptions = options.concat(value);
    }
    @api
    clear() {
        this.handleBlankOption();
    }
    @track value = [];
    @track inputValue = '';
    hasRendered;
    renderedCallback() {
        if (!this.hasRendered) {
            //  we coll the logic once, when page rendered first time
            this.handleDisabled();
        }
        this.hasRendered = true;
    }
    handleDisabled() {
        let input = this.template.querySelector("input");
        if (input) {
            input.disabled = this.disabled;
        }
    }
    comboboxIsRendered;

    handleClick() {
        let sldsCombobox = this.template.querySelector(".slds-combobox");
        sldsCombobox.classList.toggle("slds-is-open");
        if (!this.comboboxIsRendered) {
            // let noneOption = this.template.querySelector('[data-id="blank"]');
            // noneOption.firstChild.classList.add("slds-is-selected");
            this.comboboxIsRendered = true;
        }
    }

    handleSelection(event) {
        let value = event.currentTarget.dataset.value;
        // if (value === 'blank') {
        //     this.handleBlankOption();
        // }
        // else {
             this.handleOption(event, value);
        // }
        let input = this.template.querySelector("input");
        input.focus();
    }

    sendValues() {
        let values = [];
        for (const valueObject of this.value) {
            values.push(valueObject.value);
        }
        this.dispatchEvent(new CustomEvent("valuechange", {
            detail: values.toString()
        }));
    }
    // handleBlankOption() {
    //     this.value = [];
    //     this.inputValue = '--None--';
    //     let listBoxOptions = this.template.querySelectorAll('.slds-is-selected');
    //     for (let option of listBoxOptions) {
    //         option.classList.remove("slds-is-selected");
    //     }
    //     let noneOption = this.template.querySelector('[data-id="blank"]');
    //     noneOption.firstChild.classList.add("slds-is-selected");
    //     this.closeDropbox();
    // }
    handleOption(event, value) {
        let listBoxOption = event.currentTarget.firstChild;
        if (listBoxOption.classList.contains("slds-is-selected")) {
            this.value = this.value.filter(option => option.value !== value);
        }
         else {
        //     let noneOption = this.template.querySelector('[data-id="blank"]');
        //     noneOption.firstChild.classList.remove("slds-is-selected");
            let option = this.options.find(option => option.value === value);
            this.value.push(option);
        }
        if (this.value.length > 1) {
            this.inputValue = this.value.length + ' options selected';
        }
        else if (this.value.length === 1) {
            this.inputValue = this.value[0].label;
        }
        else {
            this.inputValue = '';
        }
        listBoxOption.classList.toggle("slds-is-selected");
        this.sendValues();
    }
    dropDownInFocus = false;

    handleBlur() {
        if (!this.dropDownInFocus) {
            this.closeDropbox();
        }
    }
    handleMouseleave() {
        this.dropDownInFocus = false;
    }
    handleMouseEnter() {
        this.dropDownInFocus = true;
    }
    closeDropbox() {
        let sldsCombobox = this.template.querySelector(".slds-combobox");
        sldsCombobox.classList.remove("slds-is-open");
    }
}