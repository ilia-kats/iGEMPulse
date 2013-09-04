<script>

var Filters = function() {this.initialize.apply(this, arguments)}
Filters.prototype = {
	initialize: function(filter) {
		this.FilterNodes = document.getElementById("AllFilters").childNodes;
		this.UlNodes = document.getElementById("FilterUl").childNodes;
	},
	Show: function(element, link) {
		for(var i = 0; i < this.FilterNodes.length; i++) {
			if(this.FilterNodes[i].tagName != undefined) this.FilterNodes[i].style.display = "none"
		}
		for(var i = 0; i < this.UlNodes.length; i++) {
			if (this.UlNodes[i].tagName == "LI") this.UlNodes[i].style.borderBottom = "1pt solid #BBBBBB"
		}
		document.getElementById(element).style.display = "block";
		document.getElementById(link).parentNode.style.borderBottom = "1pt solid white";
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