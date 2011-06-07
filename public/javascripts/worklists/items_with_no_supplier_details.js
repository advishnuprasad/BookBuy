function getWorklistID() {
    return $("#worklist-id").html();
}

function saveItems() {
    var changedCellsHash = {}
    var counter = 0;
    for(var i in changedCells) {
        changedCellsHash[counter++] = changedCells[i];
    }
    dataValue = {}
    dataValue["data"] = changedCellsHash;
    dataValue["id"] = getWorklistID();
    
    jQuery.post('/worklist_save_items_with_no_supplier_details',dataValue);
    clearChangedCells();
}

$(document).ready(function() {
    clearChangedCells();
});

function clearChangedCells() {
    changedCells = {};
}

$("#items .input_qty").live("change",function(event) {
    if($(this).attr('dataquantity') != this.value) {
        if(changedCells[this.id]) {
            changedCells[this.id]["quantity"] = this.value;
        }
        else {
            changedCells[this.id] = {};
            changedCells[this.id]["id"] = this.id;
            changedCells[this.id]["quantity"] = this.value;
        }
    }
    else
        if(changedCells[this.id])
            delete changedCells[this.id]["quantity"];
});

$("#items .select_supplier").live("change",function(event) {
    if($(this).attr('datasupp') != this.value) {
        if(changedCells[$(this).attr('datasuppid')]) {
            changedCells[$(this).attr('datasuppid')]["supplier_id"] = this.value;
        }
        else {
            changedCells[$(this).attr('datasuppid')] = {}
            changedCells[$(this).attr('datasuppid')]["id"] = $(this).attr('datasuppid');
            changedCells[$(this).attr('datasuppid')]["supplier_id"] = this.value;
        }
    }
    else
        if(changedCells[$(this).attr('datasuppid')])
            delete changedCells[$(this).attr('datasuppid')]["supplier_id"];
});

$("#items .select_avl").live("change",function(event) {
    if($(this).attr('dataavl') != this.value) {
        if(changedCells[$(this).attr('dataavlid')]) {
            changedCells[$(this).attr('dataavlid')]["availability"] = this.value;
        }
        else {
            changedCells[$(this).attr('dataavlid')] = {}
            changedCells[$(this).attr('dataavlid')]["id"] = $(this).attr('dataavlid');
            changedCells[$(this).attr('dataavlid')]["availability"] = this.value;
        }
    }
    else
        if(changedCells[$(this).attr('dataavlid')])
            delete changedCells[$(this).attr('dataavlid')]["availability"];
});

$("#items .select_cancel").live("change",function(event) {
    if($(this).attr('datacancel') != this.value) {
        if(changedCells[$(this).attr('datacancelid')]) {
            changedCells[$(this).attr('datacancelid')]["cancel_reason"] = this.value;
        }
        else {
            changedCells[$(this).attr('datacancelid')] = {}
            changedCells[$(this).attr('datacancelid')]["id"] = $(this).attr('datacancelid');
            changedCells[$(this).attr('datacancelid')]["cancel_reason"] = this.value;
        }
    }
    else
        if(changedCells[$(this).attr('datacancelid')])
            delete changedCells[$(this).attr('datacancelid')]["cancel_reason"];
});

$("#items .input_defer").live("change",function(event) {
    if($(this).attr('datadefer') != this.value) {
        if(changedCells[$(this).attr('datadeferid')]) {
            changedCells[$(this).attr('datadeferid')]["deferred_by"] = this.value;
        }
        else {
            changedCells[$(this).attr('datadeferid')] = {}
            changedCells[$(this).attr('datadeferid')]["id"] = $(this).attr('datadeferid');
            changedCells[$(this).attr('datadeferid')]["deferred_by"] = this.value;
        }
    }
    else
        if(changedCells[$(this).attr('datadeferid')])
            delete changedCells[$(this).attr('datadeferid')]["deferred_by"];
});
