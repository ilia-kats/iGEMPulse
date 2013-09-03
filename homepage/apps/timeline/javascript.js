<script>

var Filters = function() {this.initialize.apply(this, arguments)}
Filters.prototype = {
	initialize: function(filter) {
		document.getElementById("DropTeam").onclick = function() {Filter.Drop("DropTeam"); return(false);};
		this.Drop("DropTeam");
		document.getElementById("DropSuccess").onclick = function() {Filter.Drop("DropSuccess"); return(false);};
		this.Drop("DropSuccess");
		document.getElementById("DropGeneral").onclick = function() {Filter.Drop("DropGeneral"); return(false);};
		this.Drop("DropGeneral");
	},
	Drop: function(element) {
		var children = document.getElementById(element).parentNode.childNodes;
		for(var i=0; i<children.length; i++) {
			if(children[i].tagName == "A") {var node = i; break;}
		}
		for(var i=(node+1); i<children.length; i++) {
			if (children[i].tagName != undefined) {
				if (children[i].style.display != "none") children[i].style.display = "none";
				else children[i].style.display = "block";
			}
		}
	}
}
var Filter = new Filters(document.getElementById("Filters"));
</script>