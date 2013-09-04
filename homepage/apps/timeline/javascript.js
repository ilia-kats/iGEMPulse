<script>

var Filters = function() {this.initialize.apply(this, arguments)}
Filters.prototype = {
	initialize: function(filter) {
		this.FilterNodes = document.getElementById("AllFilters").childNodes;
	},
	Show: function(element) {
		for(var i = 0; i < this.FilterNodes.length; i++) {
			if(this.FilterNodes[i].tagName != undefined) this.FilterNodes[i].style.display = "none"
		}
		document.getElementById(element).style.display = "block";
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
var toggle = document.getElementById("Filters").getElementsByTagName("UL")[0].getElementsByTagName("A")[0];
toggle.onclick.apply(toggle);
</script>