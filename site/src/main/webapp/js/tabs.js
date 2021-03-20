// vertical tabs (side navigation)
// get needed elements
const tabs = document.querySelector('.tabs');
const tabButtons = tabs.querySelectorAll('[role="tab"]');
const tabPanels = Array.from(tabs.querySelectorAll('[role="tabpanel"]'));

function handleTabClick(event) {
    // hide all tab panels
    tabPanels.forEach( tab => {
      tab.hidden = true
    });
    //mark all tab as unselected
    tabButtons.forEach((tab) => {
      tab.setAttribute('aria-selected', false);
    });
    //mark the clicked tab as unselected
    event.currentTarget.setAttribute('aria-selected', true);
    //find associated tabpanel and show it

    const { id } = event.currentTarget;

    // find in the array of tabpanels
    const tabPanel = tabPanels.find(
      panel => panel.getAttribute('aria-labelledby') === id
    );
    tabPanel.hidden = false;
    // console.log(tabPanel);
}

tabButtons.forEach( (button) => {
  button.addEventListener('click', handleTabClick);
});


// horizontal tabs (panels)
function showAlertListing(evt, alertType) {
  // Declare all variables
  let i, tabcontent, tablinks;

  // Get all elements with class="tabcontent" and hide them
  tabcontent = document.getElementsByClassName("tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }

  // Get all elements with class="tablinks" and remove the class "active"
  tablinks = document.getElementsByClassName("tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" active", "");
  }

  // Show the current tab, and add an "active" class to the button that opened the tab
  document.getElementById(alertType).style.display = "block";
  evt.currentTarget.className += " active";
}
