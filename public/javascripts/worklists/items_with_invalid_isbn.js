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
    
    jQuery.post('/worklist_save_items_with_invalid_isbn',dataValue);
    clearChangedCells();
}

$(document).ready(function() {
    clearChangedCells();
});

function clearChangedCells() {
    changedCells = {};
}

$("#items .input_isbn").live("change",function(event) {
    if($(this).attr('dataisbn') != this.value) {
        if(changedCells[$(this).attr('dataid')]) {
            changedCells[$(this).attr('dataid')]["isbn"] = this.value;
        }
        else {
            changedCells[$(this).attr('dataid')] = {}
            changedCells[$(this).attr('dataid')]["id"] = $(this).attr('dataid');
            changedCells[$(this).attr('dataid')]["isbn"] = this.value;
        }
    }
    else
        if(changedCells[$(this).attr('dataid')])
            delete changedCells[$(this).attr('dataid')]["isbn"];
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
