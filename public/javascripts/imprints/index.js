function saveItems() {
    var changedCellsHash = {}
    var counter = 0;
    for(var i in changedCells) {
        changedCellsHash[counter++] = changedCells[i];
    }
    dataValue = {}
    dataValue["data"] = changedCellsHash;
    
    jQuery.post('/imprints/update_publishers',dataValue);
    clearChangedCells();
}

$(document).ready(function() {
    clearChangedCells();
});

function clearChangedCells() {
    changedCells = {};
}

$("#items .select_publisher").live("change",function(event) {
    if($(this).attr('datapub') != this.value) {
        if(changedCells[$(this).attr('dataimpid')]) {
            changedCells[$(this).attr('dataimpid')]["publisher_id"] = this.value;
        }
        else {
            changedCells[$(this).attr('dataimpid')] = {}
            changedCells[$(this).attr('dataimpid')]["id"] = $(this).attr('dataimpid');
            changedCells[$(this).attr('dataimpid')]["publisher_id"] = this.value;
        }
    }
    else
        if(changedCells[$(this).attr('dataimpid')])
            delete changedCells[$(this).attr('dataimpid')]["publisher_id"];
});
