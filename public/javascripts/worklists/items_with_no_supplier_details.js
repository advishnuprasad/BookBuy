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

$("#items input").live("change",function(event) {
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
