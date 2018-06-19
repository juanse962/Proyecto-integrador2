var weeksLabels = ['s1','s2','s3','s4','s5','s6','s7','s8','s9','s10','s11','s12','s13','s14','s15','s16','s17','s18','s19','s20','s21','s22','s23','s24','s25','s26','s27','s28','s29','s30','s31','s32','s33','s34','s35','s36','s37','s38','s39','s40','s41','s42','s43','s44','s45','s46','s47','s48','s49','s50','s51','s52'];
var options = {
                maintainAspectRatio: false,
                elements: {
                    line: {
                        tension: 0
                    }
                },
                scales: {
                    yAxes: [{
                        stacked: false,
                        gridLines: {
                            display: true,
                            color: "rgba(99,132,255,0.2)"
                        }
                    }],
                    xAxes: [{
                        gridLines: {
                            display: false
                        }
                    }]
                }
            }; 
var myChart = undefined;
var myLayers = undefined;
var defaultSim = {};

$(document).ready(function(){
    $("html, body").scrollTop(0);
});

function clearChart(){
    if(myChart != undefined){
        myChart.destroy();
    }
}

function initHome(){

    // fix menu when passed
    $('.masthead')
    .visibility({
    once: false,
    onBottomPassed: function() {
        $('.fixed.menu').transition('fade in');
    },
    onBottomPassedReverse: function() {
        $('.fixed.menu').transition('fade out');
    }
    });
    
    // create sidebar and attach to menu open
    $('.ui.sidebar')
        .sidebar('attach events', '.toc.item');
  
    // Show animation
    $('#top, #top-layer').addClass('moving');
    
    // Calculate offsets
    var topOffset = $("#top").offset().top;
    var modulosOffset = $("#modulos").offset().top;
    var equipoOffset = $("#equipo").offset().top;
    var patrocinadoresOffset = $("#patrocinadores").offset().top;
    var bottomOffset = $(".footer").offset().top + 150;

    $(window).scroll(function() {
        var h = window.scrollY + 100;

        $("a.active").removeClass('active');
        if(h>topOffset && h<modulosOffset){
            $("a[onclick='scroll2(\"top\")']").addClass('active');
        }else if(h>modulosOffset && h<equipoOffset){
            $("a[onclick='scroll2(\"modulos\")']").addClass('active');
        }else if(h>equipoOffset && h<patrocinadoresOffset){
            $("a[onclick='scroll2(\"equipo\")']").addClass('active');
        }else if(h>patrocinadoresOffset && bottomOffset){
            $("a[onclick='scroll2(\"patrocinadores\")']").addClass('active');
        };

        return false;
    });

}

function initData(){
    $.fn.form.settings.prompt.empty="{name} debe tener un valor";
    $('.dropdown').dropdown({
        "onChange": function(value){
            $("#ejemplo1,#ejemplo2,#ejemplo3").hide();
            if(value == "cecps"){
                $("#ejemplo1").show();
            }else if(value == "geopos"){
                $("#ejemplo2").show();
            }else if(value == "params"){
                $("#ejemplo3").show();
            }
        }
    });
    $('.ui.form').form();

    
    makeDataCharts();
}

function initChannel(){
    $.fn.form.settings.prompt.empty="{name} debe tener un valor";
    $('.dropdown').dropdown();
    $('.ui.form').form();
}

function initMap(){
    $stateLegend = $("#state-legend");

    $('.dropdown').dropdown();

    $("#year").on("input change", function(){filterMap()});
    $("#week").on("input change", function(e){
        var $slider = $("#slider");
        var week = e.target.value;

        if($slider.val() != week){
            $slider.range("set value", parseInt(week));
            filterMap(week);
        }
    });

    $("#slider").range({
        min: 0,
        max: 52,
        start: 0,
        step: 1,
        onChange: function(week, meta) {
            if(meta.triggeredByUser) {
                if(mapData != undefined){
                    filterMap(week.toString());
                }
            }
        }
    });

    $stateLegend.click(function(e){
        if($stateLegend.hasClass('hide')){
            $stateLegend.css("right","10px");
        }else{
            $stateLegend.css("right","-"+$stateLegend.width()*0.8+"px");
        };
        $stateLegend.toggleClass('hide');
    });

    $("#map-overlay *:not(div, select, option, i)").click(function(e){
        $mapOverlay = $("#map-overlay");
        if($mapOverlay.hasClass('hide')){
            $mapOverlay.css("left","0px");
        }else{
            $mapOverlay.css("left","-"+$mapOverlay.width()*0.75+"px");
        };
        $mapOverlay.toggleClass('hide');
    });

    mapboxgl.accessToken = 'pk.eyJ1IjoiY2FtaWxvbGwiLCJhIjoiY2pjOGhwdmcxMDZwZjJ3bGc3b3JiZTBtaSJ9.sc0sK9N58eXsvoWZmr_Zmw';
    map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/basic-v9',
        //style: 'mapbox://styles/mapbox/dark-v9',
        //style: 'mapbox://styles/camiloll/cjdxxow1x0hts2ss6scqunr6j',
        //style: 'mapbox://styles/camiloll/cjdxxyylm0hvd2ro28efpkqw2',        
        center: [-75.559589, 6.336729],
        zoom: 12.5
    });

    map.addControl(new mapboxgl.NavigationControl());

    map.on('load', function () {
        $.getJSON('/mapa/comunas/layers.json', function(layers){
            var numbers = Object.keys(layers).sort();
            numbers.forEach(function(number){
                $stateLegend.append('<div><span style="opacity:0.75;background-color: '+layers[number].paint["fill-color"]+'"></span>'+number+'. '+layers[number].id+'</div>')
                map.addLayer(layers[number]);
            });
        });

        $.getJSON('/mapa/casos/cases.json', function(data){
            mapData = data;

            var points = data["features"];
            var years = new Set();

            $.each(points, function(i){
                years.add(points[i]["properties"]["year"]);
            });

            $year = $("#year");
	        years.forEach(function(year){
                $year.append('<option class="item" value="'+year+'">'+year+'</option>')
            });

            map.addSource("cases", {
                type: "geojson",
                data: data,
                cluster: true,
                clusterMaxZoom: 16,
                clusterRadius: 60
            });

            map.addLayer({
                id: "clusters",
                type: "circle",
                source: "cases",
                filter: ["has", "point_count"],
                paint: {
                    "circle-color": {
                        property: "point_count",
                        type: "interval",
                        stops: [
                            [0, "#51bbd6"],
                            [100, "#f1f075"],
                            [300, "#f28cb1"],
                        ]
                    },
                    "circle-radius": {
                        property: "point_count",
                        type: "interval",
                        stops: [
                            [0, 20],
                            [100, 30],
                            [300, 40]
                        ]
                    }
                }
            });
        
            map.addLayer({
                id: "cluster-count",
                type: "symbol",
                source: "cases",
                filter: ["has", "point_count"],
                layout: {
                    "text-field": "{point_count_abbreviated}",
                    "text-font": ["DIN Offc Pro Medium", "Arial Unicode MS Bold"],
                    "text-size": 12
                }
            });
        
            map.addLayer({
                id: "unclustered-point",
                type: "circle",
                source: "cases",
                filter: ["!has", "point_count"],
                paint: {
                    "circle-color": "#11b4da",
                    "circle-radius": 4,
                    "circle-stroke-width": 1,
                    "circle-stroke-color": "#fff"
                }
            });

        })

    });
}

function initRisk(){
    $stateLegend = $("#state-legend");

    $('.dropdown').dropdown();

    $("#index").on("input change", function(){filterRiskMap()});

    $stateLegend.click(function(e){
        if($stateLegend.hasClass('hide')){
            $stateLegend.css("right","10px");
        }else{
            $stateLegend.css("right","-"+$stateLegend.width()*0.8+"px");
        };
        $stateLegend.toggleClass('hide');
    });

    $("#map-overlay *:not(div, select, option, i)").click(function(e){
        $mapOverlay = $("#map-overlay");
        if($mapOverlay.hasClass('hide')){
            $mapOverlay.css("left","0px");
        }else{
            $mapOverlay.css("left","-"+$mapOverlay.width()*0.75+"px");
        };
        $mapOverlay.toggleClass('hide');
    });

    mapboxgl.accessToken = 'pk.eyJ1IjoiY2FtaWxvbGwiLCJhIjoiY2pjOGhwdmcxMDZwZjJ3bGc3b3JiZTBtaSJ9.sc0sK9N58eXsvoWZmr_Zmw';
    map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/basic-v9',      
        center: [-75.559589, 6.336729],
        zoom: 12.5
    });

    map.addControl(new mapboxgl.NavigationControl());

    map.on('load', function () {
        $.getJSON('/riesgo/comunas/layers.json', function(layers){
            myLayers = layers;

            var numbers = Object.keys(myLayers['alpha']).sort();
            numbers.forEach(function(number){
                $stateLegend.append('<div><span style="opacity:0.75;background-color: '+myLayers['alpha'][number].paint["fill-color"]+'"></span>'+number+'. '+myLayers['alpha'][number].id+'</div>')
                map.addLayer(myLayers['alpha'][number]);
            });
        });

    });
}

function initPrediction(){

    var estimation = {
        xAxe:[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227],
        expHi:[4,3,2,3,2,9,6,3,4,6,2,1,2,1,4,1,8,0,0,6,4,3,2,1,4,2,1,3,3,0,1,2,1,4,10,4,4,1,2,2,2,2,3,3,3,4,5,4,3,9,4,5,10,12,18,7,9,8,6,5,4,2,3,8,8,11,4,6,3,7,9,11,4,7,6,7,6,13,8,9,10,9,11,6,12,18,8,3,3,12,9,5,8,8,15,6,9,11,16,7,9,6,4,10,11,8,16,13,14,5,9,8,13,8,2,5,11,7,8,6,8,7,7,7,8,15,9,13,8,8,7,5,3,1,4,7,2,4,3,8,6,5,5,6,5,9,15,18,20,22,19,36,25,30,36,21,31,18,25,21,13,17,20,11,13,14,11,3,16,6,5,9,6,6,13,13,15,12,4,7,6,2,3,7,5,3,3,3,6,3,8,3,6,5,3,4,5,5,8,11,12,8,10,9,14,12,6,4,11,12,16,20,21,15,18,24,26,17,16,13,11,17,18,26,33,27,28],
        estHi:[3,5,2,3,2,7,3,6,7,7,2,3,3,2,3,2,8,0,0,4,6,4,2,3,4,2,2,3,3,0,4,4,1,4,13,5,4,2,4,4,6,2,4,3,4,5,5,6,6,8,6,6,15,11,9,7,11,8,7,6,5,3,2,6,9,8,7,3,5,8,13,8,6,7,11,8,5,13,7,10,7,10,15,4,13,13,14,3,3,14,9,4,7,5,10,11,7,10,17,6,6,4,4,12,10,9,10,11,22,5,8,12,9,12,2,7,8,9,8,5,16,9,11,9,11,13,10,11,6,9,9,8,5,2,2,7,2,6,3,16,5,10,7,7,5,9,12,16,18,22,11,33,25,21,37,18,20,16,24,23,8,16,12,8,8,11,6,5,12,9,10,7,9,3,9,9,13,16,10,7,9,1,5,7,3,3,3,3,7,4,12,3,17,9,2,4,11,7,6,6,15,7,15,7,19,8,7,5,16,10,12,18,17,17,13,17,22,14,10,28,13,13,17,20,30,24,21]
    };

    var prediction = {
        xAxe:[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50],
        expHi:[12,4,7,6,2,3,7,5,3,3,3,6,3,8,3,6,5,3,4,5,5,8,11,12,8,10,9,14,12,6,4,11,12,16,20,21,15,18,24,26,17,16,13,11,17,18,26,33,27,28],
        predHi:[16,10,7,9,1,5,7,3,2,3,3,7,4,12,3,17,9,2,4,11,7,6,6,15,7,15,7,19,8,7,5,16,10,12,18,17,17,14,17,22,14,10,28,13,13,17,20,30,24,21]
    };

    new Chart("chart-est", {
        type: 'bar',
        data: {
          labels: estimation.xAxe,
          datasets: [{
                        label: 'Datos de campo',
                        backgroundColor: "rgba(255,99,132,0.2)",
                        borderColor: "rgba(255,99,132,1)",
                        borderWidth: 0.7,
                        hoverBackgroundColor: "rgba(255,99,132,0.4)",
                        hoverBorderColor: "rgba(255,99,132,1)",
                        data: estimation.expHi
                    }, {
                        label: 'Casos por semana - [2011 - 2015]',
                        borderColor: "#3e95cd",
                        borderWidth:1.2,
                        fill: false,
                        data: estimation.estHi,
                        type: 'line'
                    }]
        },
        options: options
    });

    new Chart("chart-pred", {
        type: 'bar',
        data: {
          labels: prediction.xAxe,
          datasets: [{
                        label: 'Datos de campo',
                        backgroundColor: "rgba(255,99,132,0.2)",
                        borderColor: "rgba(255,99,132,1)",
                        borderWidth: 1.5,
                        hoverBackgroundColor: "rgba(255,99,132,0.4)",
                        hoverBorderColor: "rgba(255,99,132,1)",
                        data: prediction.expHi
                    }, {
                        label: 'Casos por semana - 2015',
                        borderColor: "#3e95cd",
                        fill: false,
                        data: prediction.predHi,
                        type: 'line'
                    }]
        },
        options: options
    });

}

function initSimulator(){
    $.fn.form.settings.prompt.empty="{name} debe tener un valor";
    $('.ui.form').form();

    var expHi = JSON.parse('['+$('#chart-sim').html()+']');
    var cases = expHi.length;
    var xAxe = [];

    for(var i=0;i<cases;i++){
        xAxe.push(i+1);
    };

    $('.simParam[data-param="tMax"]').val(cases);
    
    defaultSim = {
        xAxe:xAxe,
        expHi:expHi,
        params:{}
    };
    
    $('.simParam').toArray().forEach(function(e){
        $e = $(e);
        var param = $e.data("param");
        var value = $e.val();
        defaultSim.params[param] = value;
    });

    myChart = new Chart("chart-sim", {
        type: 'line',
        data: {
          labels: defaultSim.xAxe,
          datasets: [ {
              data: defaultSim.expHi,
              label: "Datos de campo",
              borderColor: "#99A3A4",
              fill: false
            }
          ],
        },
        options: options
    });

    $('.remPulse').click(function(){
        var pulseN = $('.pulses').children().length;
        $('.pulses [data-pulse='+pulseN+']').remove();
    });

    $('.addPulse').click(function(){
        var pulseN = $('.pulses').children().length+1;
        pulseHTML = '<div class="three fields" data-pulse="'+pulseN+'"> <div class="field"> <label>Intensidad '+pulseN+'</label> <input class="simParam" data-param="A_c'+pulseN+'" type="text" value=""/> </div> <div class="field"> <label>Semana inicial '+pulseN+'</label> <input class="simParam" data-param="t0_c'+pulseN+'" type="text" value=""/> </div> <div class="field"> <label>Duración '+pulseN+'</label> <input class="simParam" data-param="dt_c'+pulseN+'" type="text" value=""/> </div> </div>';
        $('.pulses').append(pulseHTML);
    });
}

function makeSimulation(){
    var $btnSim = $('#btnSim');
    var simulationParams = {};

    $('.simParam').toArray().forEach(function(e){
        $e = $(e);
        var param = $e.data("param");
        var value = $e.val();
        simulationParams[param] = value;
    });

    $btnSim.addClass('disabled');
    $btnSim.html('Cargando...');

    $.post('/simulador/sim',{"params":JSON.stringify(simulationParams)}).done(function(data){
        $btnSim.removeClass('disabled');
        $btnSim.html('Simular');

        clearChart();
        
        myChart = new Chart("chart-sim", {
            type: 'line',
            data: {
              labels: data.xAxe,
              datasets: [
                {
                  data: data.simHi,
                  label: "Humanos Infectados",
                  borderColor: "#3e95cd",
                  fill: false
                },{
                  data: data.controlPulse,
                  label: "Control por fumigación",
                  borderColor: "#8e5ea2",
                  fill: false
                }, {
                  data: defaultSim.expHi,
                  label: "Datos de campo",
                  borderColor: "#99A3A4",
                  fill: false
                }
              ],
            },
            options: options
        });

        $("html, body").animate({ scrollTop: $(document).height() }, 1000);

        if(data.error == "-1"){
            alert('Error en la simulación, intente cambiar los parámetros.');
        }else if(data.error == "-2"){
            alert('Error, tMax debe ser mayor a cero y menor a 1000.');
        };
       
    }).fail(function(error){
        console.log(error);
        alert('Error en el servidor, por favor intente más tarde.');
        $btnSim.removeClass('disabled');
        $btnSim.html('Simular');
    });
}

function resetParams(number_c){
    var pulseN = $('.pulses').children().length;

    while (pulseN<number_c){
        $('.addPulse').click();
        pulseN += 1;
    }

    while (pulseN>number_c){
        $('.remPulse').click();
        pulseN -= 1;
    }

    $('.simParam').toArray().forEach(function(e){
        $e = $(e);
        var param = $e.data("param");
        $e.val(defaultSim.params[param]);
    });
}

function toggleParams(){
    $simParams = $('.simParams');
    
    if($simParams.css('display') == 'none'){
        $simParams.show();
    }else{
        $simParams.hide();
    }
}

function makeChannel(){
    var channelYear = $('#channelYear').val();
    var channelYears = $('#channelYears').val();
    var channelMethod = $('#channelMethod').val();

    $.post('/canal/crear',{channelYear:channelYear,channelYears:channelYears,channelMethod:channelMethod}, function(data){
        if(data.error == undefined){
            $('.ui.bottom.message').html('<i class="icon check"></i> El canal endémico para el año '+channelYear+' fue creado correctamente.');

            var base = data['base'];
            var inf  = data['inf'];
            var med = data['med'];
            var sup = data['sup'];

            var chartData = {
                datasets: [{
                        label: 'Casos por semana - '+channelYear,
                        backgroundColor: "rgba(25,25,25,0.2)",
                        borderColor: "rgba(25,25,25,1)",
                        borderWidth: 2,
                        hoverBackgroundColor: "rgba(0,0,0,0.4)",
                        hoverBorderColor: "rgba(0,0,0,1)",
                        data: base
                    }, {
                        label: 'Zona de éxito',
                        backgroundColor: "rgba(75,140,97,0.2)",
                        borderColor: "rgba(75,140,97,1)",
                        borderWidth: 2,
                        hoverBackgroundColor: "rgba(75,140,97,0.4)",
                        hoverBorderColor: "rgba(75,140,97,1)",
                        fill: 'origin',
                        data: inf,
                        type: 'line'
                    }, {
                        label: 'Zona de seguridad',
                        backgroundColor: "rgba(252,226,5,0.2)",
                        borderColor: "rgba(252,226,5,1)",
                        borderWidth: 2,
                        hoverBackgroundColor: "rgba(252,226,5,0.4)",
                        hoverBorderColor: "rgba(252,226,5,1)",
                        fill: 1,
                        data: med,
                        type: 'line'
                    }, {
                        label: 'Zona de alerta',
                        backgroundColor: "rgba(241,25,0,0.2)",
                        borderColor: "rgba(241,25,0,1)",
                        borderWidth: 2,
                        hoverBackgroundColor: "rgba(241,25,0,0.4)",
                        hoverBorderColor: "rgba(241,25,0,1)",
                        fill: 2,
                        data: sup,
                        type: 'line'
                    }],
                labels: weeksLabels
            };

            clearChart();

            myChart = new Chart('chart-channel', {
                type: 'bar',
                data: chartData,
                options: options
            });
            $("html, body").animate({ scrollTop: $(document).height() }, 1000);
        }else{
            $('.ui.bottom.message').html('<i class="icon warning"></i>'+data.error);
            clearChart();
        }
    })
};

function makeDataCharts(){
    $('canvas').each(function(i,e){
        $e = $(e);
        var year = $e.data('year');
        var data = {
                        labels: weeksLabels,
                        datasets: [{
                            label:'Casos por semana - '+year,
                            backgroundColor: "rgba(255,99,132,0.2)",
                            borderColor: "rgba(255,99,132,1)",
                            borderWidth: 2,
                            hoverBackgroundColor: "rgba(255,99,132,0.4)",
                            hoverBorderColor: "rgba(255,99,132,1)",
                            data: JSON.parse($e.html()),
                        }]
                    };
        
        Chart.Bar($e, {
            options: options,
            data: data
        });
    });
};

function removeDataYear(id){
    $td = $('#'+id);
    year = $td.data('year');
    
    if(confirm('¿Desea eliminar los datos del año '+year+'?')){
        $.post("/data/remove",{yearId:id}, function(r){
           if(r=='1'){$td.remove()};
        });
    }
};

function scroll2(id){
    $('html, body').animate({
        scrollTop: $("#"+id).offset().top
    }, 1500).then(function(){
        $("a.active").removeClass('active');
        $("a[onclick='scroll2(\""+id+"\")']").addClass('active');
    });
}

function downloadDataYear(id){
    window.location.href = "/data/download/"+id;   
};

var map, mapData;

function filterMap(week){
    var year = $("#year").val();
    var features = mapData["features"];
    var featuresFiltered = [];

    if(year == "0" && week == "0"){
        featuresFiltered = features;
    }else if(year == "0"){
        features.forEach(function(n){
            if(n.properties.week == week){
                featuresFiltered.push(n);
            }
        })
    }else if(week == "0"){
        features.forEach(function(n){
            if(n.properties.year == year){
                featuresFiltered.push(n);
            }
        })
    }else{
        features.forEach(function(n){
            if(n.properties.year == year && n.properties.week == week){
                featuresFiltered.push(n);
            }
        })
    }
    
    var filteredData = JSON.parse(JSON.stringify(mapData));
        filteredData.features = featuresFiltered;
    map.getSource('cases').setData(filteredData);

    // document.getElementById('weekLabel').textContent = week==0?'Todas las semanas':'Semana '+week;
    
    $week = $("#week");
    if($week.val() != week){
        $week.dropdown("set selected", week);
    }
}

function filterRiskMap(){
    var index = $("#index").val();
    $stateLegend = $("#state-legend");

    map.remove();
    $stateLegend.html('<h4>Comunas</h4>');
    map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/basic-v9',      
        center: [-75.559589, 6.336729],
        zoom: 12.5
    });

    map.addControl(new mapboxgl.NavigationControl());

    map.on('load', function () {
        if(index == 'alpha'){
            var numbers = Object.keys(myLayers['alpha']).sort();
            numbers.forEach(function(number){
                $stateLegend.append('<div><span style="opacity:0.75;background-color: '+myLayers['alpha'][number].paint["fill-color"]+'"></span>'+number+'. '+myLayers['alpha'][number].id+'</div>')
                map.addLayer(myLayers['alpha'][number]);
            }); 
        }else if(index == 'beta'){
            
            var numbers = Object.keys(myLayers['beta']).sort();
            numbers.forEach(function(number){
                $stateLegend.append('<div><span style="opacity:0.75;background-color: '+myLayers['beta'][number].paint["fill-color"]+'"></span>'+number+'. '+myLayers['beta'][number].id+'</div>')
                map.addLayer(myLayers['beta'][number]);
            }); 
        };

    });
}