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

$("#items .input_verified").live("change",function(event) {
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

$("#items .input_author").live("change",function(event) {
    if($(this).attr('dataauthor') != this.value) {
        if(changedCells[$(this).attr('dataid')]) {
            changedCells[$(this).attr('dataid')]["author"] = this.value;
        }
        else {
            changedCells[$(this).attr('dataid')] = {}
            changedCells[$(this).attr('dataid')]["id"] = $(this).attr('dataid');
            changedCells[$(this).attr('dataid')]["author"] = this.value;
        }
    }
    else
        if(changedCells[$(this).attr('dataid')])
            delete changedCells[$(this).attr('dataid')]["author"];
});

$("#items .input_publisher").live("change",function(event) {
    if($(this).attr('datapublisher') != this.value) {
        if(changedCells[$(this).attr('dataid')]) {
            changedCells[$(this).attr('dataid')]["publisher"] = this.value;
        }
        else {
            changedCells[$(this).attr('dataid')] = {}
            changedCells[$(this).attr('dataid')]["id"] = $(this).attr('dataid');
            changedCells[$(this).attr('dataid')]["publisher"] = this.value;
        }
    }
    else
        if(changedCells[$(this).attr('dataid')])
            delete changedCells[$(this).attr('dataid')]["publisher"];
});

$("#items .input_title").live("change",function(event) {
    if($(this).attr('datatitle') != this.value) {
        if(changedCells[$(this).attr('dataid')]) {
            changedCells[$(this).attr('dataid')]["title"] = this.value;
        }
        else {
            changedCells[$(this).attr('dataid')] = {}
            changedCells[$(this).attr('dataid')]["id"] = $(this).attr('dataid');
            changedCells[$(this).attr('dataid')]["title"] = this.value;
        }
    }
    else
        if(changedCells[$(this).attr('dataid')])
            delete changedCells[$(this).attr('dataid')]["title"];
});

$("#items .input_price").live("change",function(event) {
    if($(this).attr('dataprice') != this.value) {
        if(changedCells[$(this).attr('dataid')]) {
            changedCells[$(this).attr('dataid')]["price"] = this.value;
        }
        else {
            changedCells[$(this).attr('dataid')] = {}
            changedCells[$(this).attr('dataid')]["id"] = $(this).attr('dataid');
            changedCells[$(this).attr('dataid')]["price"] = this.value;
        }
    }
    else
        if(changedCells[$(this).attr('dataid')])
            delete changedCells[$(this).attr('dataid')]["price"];
});
