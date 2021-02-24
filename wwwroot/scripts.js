// JScript File

function getQueryVariable(variable)
{
  var query = window.location.search.substring(1);
  var vars = query.split("&");
  for (var i=0;i<vars.length;i++)
  {
    var pair = vars[i].split("=");
    if (pair[0] == variable)
    {
      return pair[1];
    }
  } 
}
      
function redirect()
{
  var lessonId = getQueryVariable("lessonid");
  window.location = "lessonentries.aspx?lessonid=" + lessonId;
}
     
function updateOrder()
{
  var options =
  {
    method : 'post',
    parameters : Sortable.serialize('sortablecards')
  };
  
  var lessonId = getQueryVariable("lessonid");
  alert("Your cards are being reordered.  This page will redirect in 2 seconds.");
  new Ajax.Request('updateorder.aspx?lessonid=' + lessonId, options);
  setTimeout("redirect()", 2000);
}

function solo(elementId)
{
    var theCheckbox = document.getElementById(elementId);
    var checked = theCheckbox.checked == true;
    new Ajax.Request('togglesolo.aspx?entryid=' + elementId.toString().replace('cb_', '') + '&checked=' + checked);
}

function insertOrDeleteFromLessonGroup(elementId)
{
    var theDiv = document.getElementById(elementId);
    var checked = theDiv.innerHTML.indexOf("LessonIsNotPartOfLessonGroup") > 0;
    var ids = elementId.toString().replace('cb_', '');
    var I = ids.split('_');
    var lessonGroupId = I[0].replace('lg', '');
    var lessonId = I[1].replace('l', '');

    if (checked == true)
    {
        theDiv.innerHTML = theDiv.innerHTML.replace("LessonIsNotPartOfLessonGroup", "LessonIsPartOfLessonGroup");
        theDiv.style.backgroundColor = "yellow";
    }
    else
    {
        theDiv.innerHTML = theDiv.innerHTML.replace("LessonIsPartOfLessonGroup", "LessonIsNotPartOfLessonGroup");
        theDiv.style.backgroundColor = "#cccccc";
    }
    
    new Ajax.Request('lessongrouplesson.aspx?lg=' + lessonGroupId + '&l=' + lessonId + '&checked=' + checked);
}

