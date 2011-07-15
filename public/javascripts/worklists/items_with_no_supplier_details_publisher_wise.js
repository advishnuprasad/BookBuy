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
    
    jQuery.post('/worklist_save_items_with_no_supplier_details_publisher_wise',dataValue);
    clearChangedCells();
}

$(document).ready(function() {
    clearChangedCells();
});

function clearChangedCells() {
    changedCells = {};
}

$("#items .select_supplier_wide").live("change",function(event) {
    if($(this).attr('datasupp') != this.value) {
        if(changedCells[$(this).attr('dataid')]) {
            changedCells[$(this).attr('dataid')]["supplier_id"] = this.value;
        }
        else {
            changedCells[$(this).attr('dataid')] = {}
            changedCells[$(this).attr('dataid')]["id"] = $(this).attr('dataid');
            changedCells[$(this).attr('dataid')]["supplier_id"] = this.value;
        }
    }
    else
        if(changedCells[$(this).attr('dataid')])
            delete changedCells[$(this).attr('dataid')]["supplier_id"];
});

