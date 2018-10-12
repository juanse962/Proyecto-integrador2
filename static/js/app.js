var weeksLabels = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52'];
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
                        },scaleLabel: {
                            display: true,
                            labelString: 'Personas Infectadas'
                        }
                    }],
                    xAxes: [{
                        gridLines: {
                            display: false
                        },scaleLabel: {
                            display: true,
                            labelString: 'Tiempo (Semanas)'
                        }
                    }]
                },
                tooltips: {
                    enabled: true,
                    intersect: false,
                    mode: 'index',
                    callbacks: {
                      title: (items, data) => 'Semana '+data.labels[items[0].index]
                    }
                }
            };

var map, mapPoints, drawPolygon, myChart, myLayers;
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

    $("#year").on("input change", function(){
        filterMap()
    });
    
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
                if(mapPoints != undefined){
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
        center: [-75.559589, 6.336729],
        zoom: 12.5
    });

    drawPolygon = new MapboxDraw({
        displayControlsDefault: false,
        controls: {
            polygon: true,
            trash: true
        }
    });

    map.on('draw.create', updateArea);
    map.on('draw.delete', updateArea);
    map.on('draw.update', updateArea);
    map.addControl(drawPolygon);
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
            mapPoints = data;

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
        xAxe:[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264],
        expHi:[4, 11, 6, 7, 5, 3, 7, 5, 2, 7, 4, 4, 1, 7, 6, 5, 3, 3, 5, 5, 7, 2, 1, 2, 3, 2, 1, 4, 7, 4, 4, 3, 2, 3, 10, 1, 0, 3, 3, 4, 4, 4, 1, 6, 4, 4, 3, 3, 0, 0, 2, 0, 2, 1, 3, 1, 1, 3, 1, 2, 0, 0, 3, 0, 1, 2, 3, 1, 5, 5, 2, 0, 1, 1, 0, 0, 2, 0, 2, 4, 4, 2, 10, 5, 3, 4, 2, 2, 4, 5, 1, 5, 3, 2, 5, 3, 2, 5, 5, 8, 6, 8, 4, 8, 6, 18, 13, 15, 14, 22, 28, 48, 44, 43, 35, 50, 53, 47, 39, 35, 53, 44, 38, 64, 61, 53, 63, 51, 48, 48, 44, 43, 35, 48, 57, 61, 47, 32, 42, 47, 30, 25, 23, 13, 20, 15, 14, 8, 12, 12, 7, 3, 5, 2, 1, 1, 2, 9, 6, 10, 1, 2, 2, 3, 2, 2, 5, 2, 1, 3, 7, 5, 2, 4, 2, 3, 2, 1, 1, 2, 2, 0, 0, 2, 2, 3, 1, 6, 1, 9, 8, 3, 3, 2, 2, 2, 8, 6, 3, 3, 6, 2, 1, 2, 0, 3, 1, 6, 0, 1, 6, 3, 3, 2, 1, 3, 2, 1, 3, 3, 0, 1, 2, 1, 1, 10, 4, 2, 1, 2, 1, 2, 2, 3, 3, 2, 3, 5, 3, 3, 9, 4, 4, 10, 9, 15, 7, 9, 7, 5, 2, 4, 2, 3, 7, 7, 11, 4, 6, 3, Number.Nan],
        predHi:[Number.Nan, 5.899768907751515, 4.315862481934559, 2.7005244967683666, 2.807595829194142, 7.099612115047879, 3.8836929355754677, 5.644991222408057, 2.595516325602361, 1.4163874113850028, 4.100612122492734, 1.0998809472198303, 6.85226781298751, 1.4094765248524226, 3.930942531806167, 3.1000377061748914, 1.8413862738919455, 3.5152400040168317, 2.8322823345001638, 3.55528122185601, 1.8997393944590186, 1.4094765248524226, 1.8995690158238006, 3.930942531806167, 2.7718386322753616, 1.1003490564299483, 3.899727056209054, 7.099612030726407, 2.4452332151276863, 4.899746777181903, 2.1414407166364384, 5.068617040071803, 3.0997762972323066, 9.8996965258225, 1.0996973978678675, 2.045621751295002, 3.1000922981453662, 3.6855211059169584, 3.7608670433685205, 28.25208386575407, 3.9003065911723027, 1.0997153880499617, 6.100207133088869, 4.100181607734605, 4.099713812133409, 2.6679279434336145, 3.099960419664498, 0, 0.10018738840061658, 4.059680044281194, 2.66111518909689, 1.9000874332091264, 1.8427419405340828, 4.248425978790451, 1.0996751324171186, 1.1877091772797144, 3.100339778663095, 2.807595829194142, 3.391062460499791, 1.012475467592136, 0.1004788737698945, 2.595516325602361, 1.4163874113850028, 0.9004086829713884, 2.712139263637013, 2.8998576092147292, 1.1002001636173162, 4.443365617593065, 5.100468954937423, 5.2416421380865295, 3.5152400040168317, 2.8322823345001638, 2.092941332205882, 2.8852640127450506, 1.4094765248524226, 2.653320618135453, 3.930942531806167, 2.1717034883127297, 5.964430811374715, 4.443365617593065, 4.303778084268728, 10.100107557282472, 4.899746777181903, 3.0995154529693636, 2.092941332205882, 10.122105023021765, 2.0998195683439818, 4.10008319599301, 11.373563260357964, 0.8996688669632711, 3.6855211059169584, 5.943926908165981, 4.019055730196541, 2.403202934730576, 2.8998321264769, 2.09963577866338, 4.059574563567466, 3.3817780411716143, 5.899960986567661, 5.589972954338943, 3.8950189549204737, 4.099741160774201, 8.100237205923465, 2.66111518909689, 3.702493410132533, 12.900039019781259, 14.899931101344706, 14.099972727346351, 21.899889174188615, 27.90013229206177, 47.900476453698005, 43.899680014616024, 42.899691900037084, 34.900013486661095, 49.900197278921354, 52.89999148626497, 46.899816488764, 38.90026941162475, 42.87033326054892, 52.900087272400455, 43.900011877599496, 37.90001328091632, 63.89983353132844, 60.900003908853584, 52.89982556683843, 10.037802973422432, 51.09991855035648, 47.9001936643581, 47.89985854199156, 43.90006204129878, 42.89956514895057, 35.10029538149111, 47.89985233239847, 43.91700867102212, 59.824702882032135, 46.8997891756529, 11.746361206497621, 6.0708481817729005, 47.099831979721074, 1.9529238272084903, 25.10018886341298, 2.7020780561961217, 12.90025791819697, 17.220963808267364, 4.7792713459396925, 14.09995577322887, 1.538439079733834, 5.964430811374715, 12.099590717572248, 5.8018527154050386, 2.900397613225694, 5.100304757423075, 1.4428898392343257, 1.900132443903079, 3.644772588585889, 1.8997393944590186, 7.513794392023746, 7.513794392023746, 5.516513770798401, 3.1585438779026873, 2.6255670382534504, 8.896510842420751, 3.1001566082134, 5.375596577303925, 2.5164319641992137, 4.900109486636085, 1.0457923462968068, 0.8998363870529538, 2.8995168127670414, 6.899735303751596, 4.900065839086638, 3.646458655620151, 1.8395564518278427, 4.966882429459099, 3.100211117024104, 1.9001505310038063, 7.534034501925014, 1.0997420726738056, 3.5562661550707535, 2.099792277686266, 0, 2.068469863675631, 2.1004222002933233, 3.1075512901297877, 1.356865766910758, 1.099765898597198, 3.881444823419642, 1.8694691713912306, 9.099969245562946, 7.899754774988194, 2.899803352561145, 3.0995537669224493, 1.9904152673174416, 1.8999123334227974, 2.100283136531779, 1.9442690939301706, 5.899960986567661, 3.541681754040882, 3.1005355957226257, 5.498743717266386, 1.0634661876930664, 1.1002345260867585, 2.100029529065864, 1.455858582084474, 1.7553354722810681, 1.7201926344240377, 6.100502964057892, 2.096208335865633, 3.2978314535530693, 3.9768749576447657, 3.1003189045371613, 3.1001290416610683, 1.8997148914243063, 0.7816210379135384, 3.1005177436186795, 1.9002752186810845, 1.0997252535883995, 3.933555165879282, 0, 1.9792171825123717, 1.099953519537415, 2.099785260599816, 5.362711892697002, 1.100446678533988, 5.327601534700852, 7.1233450957746705, 1.900132443903079, 2.1075158819684425, 4.397379465476764, 3.39712485533137, 1.9005552087580284, 2.899924800732556, 2.230337662936151, 0, 2.1000206783244835, 4.752855445657028, 4.8068740537114145, 2.899924800732556, 3.0999100879938677, 2.9543723534017268, 2.896967164768194, 4.0996097443424855, 1.947917728867914, 8.899918286283198, 15.10011782808592, 5.681858176648715, 8.900055770959927, 3.766184262692141, 4.5451906324030045, 2.0996632277310354, 3.900234012881464, 1.4757637111577964, 2.755343102368748, 6.450720593501888, 11.438733837094002, 10.900322466466122, 4.638573406069165, 4.361533657184944, 1.9598202603642534, 2.653320618135453, 10.128233122906424], 
        y_future:[Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN, Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,       Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,       Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,       Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,       Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,       Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,       Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,       Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,       Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,       Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,       Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,Number.NaN,       Number.NaN,Number.NaN,Number.NaN, Number.NaN,10.128233122906424, 2.65332062, 1.95982026]
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
                        fill: false,
                        borderWidth: 1.5,
                        hoverBackgroundColor: "rgba(255,99,132,0.4)",
                        hoverBorderColor: "rgba(255,99,132,1)",
                        data: prediction.expHi,
                        type: 'line'
                    }, {
                        label: 'Casos por semana - 2015',
                        borderColor: "#3e95cd",
                        borderWidth: 1.5,
                        fill: false,
                        data: prediction.predHi,
                        type: 'line'
                    }, {
                        label: 'Prediccion (3 dias despues)',
                        backgroundColor: "rgba(255,255,132,0.2)",
                        borderColor: '#ffff00',
                        borderWidth: 1.5, 
                        data: prediction.y_future,
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
              label: "Datos experimentales",
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
                  label: "Casos estimados",
                  borderColor: "#3e95cd",
                  fill: false
                },{
                  data: data.controlPulse,
                  label: "Control por fumigación",
                  borderColor: "#8e5ea2",
                  fill: false
                }, {
                  data: defaultSim.expHi,
                  label: "Datos experimentales",
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

var updateArea = function(e,dataFiltered) {
    var data = dataFiltered;

    if(data === undefined){
        data = mapPoints;
    };

    var dataPolygon = drawPolygon.getAll();
    var $calculationData = $('#calculated-data');
    var areaHTML = document.getElementById('calculated-area');
    var casesHTML = document.getElementById('calculated-cases');
    var densityHTML = document.getElementById('calculated-density');
    
    if (dataPolygon.features.length > 0) {
        $calculationData.show();
        
        var area = turf.area(dataPolygon);
        var rounded_area = area.toExponential(3);
        var points_inside = turf.within(data,dataPolygon).features.length;
        var density = (points_inside/rounded_area).toExponential(3);
        
        areaHTML.innerHTML = '<label style="font-family: monospace;">Area: ' + rounded_area + ' [m<sup>2</sup>]</label>';
        casesHTML.innerHTML = '<label style="font-family: monospace;">Casos: ' + points_inside + ' [I]nfectados</label>';
        densityHTML.innerHTML = '<label style="font-family: monospace;">Densidad: ' + density + ' [I/m<sup>2</sup>]</label>';
    }else if(e !== undefined){
        $calculationData.hide();
        areaHTML.innerHTML = '';
        casesHTML.innerHTML = '';
        densityHTML.innerHTML = '';
    }
};

function filterMap(week){
    var year = $("#year").val();
    var features = mapPoints["features"];
    var featuresFiltered = [];

    if(year == "0" && week == "0"){
        featuresFiltered = features;
    }else if(year == "0"){
        features.forEach(function(n){
            if(n.properties.week == week){
                featuresFiltered.push(n);
            }
        })
    }else if(week == "0" || week == undefined){
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
    
    var filteredData = JSON.parse(JSON.stringify(mapPoints));
        filteredData.features = featuresFiltered;
        updateArea(undefined,filteredData);
        
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
