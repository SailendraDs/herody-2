function states(country){
    var fd = new FormData();
    fd.append('country',country);
    $.ajax({
        type:'POST',
        url: window.__INITIAL_STATE__+'/getstates',
        headers: {'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')},
        data:fd,
        contentType: false,
        processData: false,
        success:function(data){
            $("#states").html("");
            data.states.forEach(function(state){
                $("#states").append("<option value=\""+state.name+"\">"+state.name+"</option>");
            });
        }
    });
}
function cities(state){
    var fd = new FormData();
    fd.append('state',state);
    $.ajax({
        type:'POST',
        url: window.__INITIAL_STATE__+'/getcities',
        headers: {'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')},
        data:fd,
        contentType: false,
        processData: false,
        success:function(data){
            $("#cities").html("");
            data.cities.forEach(function(city){
                $("#cities").append("<option value=\""+city.name+"\">"+city.name+"</option>");
            });
        }
    });
}
$("#countries").change(function(){
    $("#countries").change(states($("#countries").val()));
})

$("#states").change(function(){
    $("#states").change(cities($("#states").val()));
})
