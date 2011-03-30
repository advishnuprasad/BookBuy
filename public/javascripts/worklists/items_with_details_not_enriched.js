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
    
    jQuery.post('/worklist_save_items_with_details_not_enriched',dataValue);
    clearChangedCells();
}

$(document).ready(function() {
    clearChangedCells();
});

function clearChangedCells() {
    changedCells = {};
}

$("#items input").live("change",function(event) {
    var val = this.checked?'Y':'N';
    if($(this).attr('dataverified') != val) {
        if(changedCells[$(this).attr('dataid')]) {
            changedCells[$(this).attr('dataid')]["verified"] = val;
        }
        else {
            changedCells[$(this).attr('dataid')] = {}
            changedCells[$(this).attr('dataid')]["id"] = $(this).attr('dataid');
            changedCells[$(this).attr('dataid')]["verified"] = val;
        }
    }
    else
        if(changedCells[$(this).attr('dataid')])
            delete changedCells[$(this).attr('dataid')]["verified"];
});
