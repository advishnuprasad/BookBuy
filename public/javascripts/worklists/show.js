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
    
    alert(dataValue.toSource());
    jQuery.post('/worklist_save_items',dataValue);
    changedCells = {};
}

$(document).ready(function() {
    changedCells = {};
});

$("#items input").live("change",function(event) {
    if($(this).attr('dataquantity') != this.value)
        changedCells[this.id] = {id:this.id, quantity:this.value};
    else
        if(changedCells[this.id])
            delete changedCells[this.id];
});
