// admin partner #navigationMenu
function mainMenu(){
$("#navigationMenu li").hover(function(){
	$(this).find('ul:first').css({visibility: "visible",display: "none"}).show(0);
	},function(){
	$(this).find('ul:first').css({visibility: "hidden"});
	});
}
$(document).ready(function(){
	mainMenu();
});

// client #navigationmenu
function mainmenu(){
$("#navigationmenu li").hover(function(){
	$(this).find('ul:first').css({visibility: "visible",display: "none"}).show(0);
	},function(){
	$(this).find('ul:first').css({visibility: "hidden"});
	});
}
$(document).ready(function(){
	mainmenu();
});


//  ul.account
function submenu(){
$(".account li").hover(function(){
	$(this).find('ul:first').css({visibility: "visible",display: "none"}).show(0);
	},function(){
	$(this).find('ul:first').css({visibility: "hidden"});
	});
}
$(document).ready(function(){
	submenu();
});