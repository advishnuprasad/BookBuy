function saveItems() {
    var changedCellsHash = {}
    var counter = 0;
    for(var i in changedCells) {
        changedCellsHash[counter++] = changedCells[i];
    }
    dataValue = {}
    dataValue["data"] = changedCellsHash;
    
    jQuery.post('/supplierdiscounts/update_records',dataValue);
    clearChangedCells();
}

$(document).ready(function() {
    clearChangedCells();
});

function clearChangedCells() {
    changedCells = {};
}

$("#items .input_discount").live("change",function(event) {
    if($(this).attr('datadiscount') != this.value) {
        if(changedCells[$(this).attr('dataid')]) {
            changedCells[$(this).attr('dataid')]["discount"] = this.value;
        }
        else {
            changedCells[$(this).attr('dataid')] = {}
            changedCells[$(this).attr('dataid')]["id"] = $(this).attr('dataid');
            changedCells[$(this).attr('dataid')]["discount"] = this.value;
        }
    }
    else
        if(changedCells[$(this).attr('dataid')])
            delete changedCells[$(this).attr('dataid')]["discount"];
});

$("#items .input_bulkdiscount").live("change",function(event) {
    if($(this).attr('databulkdiscount') != this.value) {
        if(changedCells[$(this).attr('dataid')]) {
            changedCells[$(this).attr('dataid')]["bulkdiscount"] = this.value;
        }
        else {
            changedCells[$(this).attr('dataid')] = {}
            changedCells[$(this).attr('dataid')]["id"] = $(this).attr('dataid');
            changedCells[$(this).attr('dataid')]["bulkdiscount"] = this.value;
        }
    }
    else
        if(changedCells[$(this).attr('dataid')])
            delete changedCells[$(this).attr('dataid')]["bulkdiscount"];
});
