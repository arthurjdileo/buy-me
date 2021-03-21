var url = document.URL;
var id = '';
  if (!url.substring(url.lastIndexOf('#') ).includes('#')) {
    if(url.includes('admin')) {
      id = 'create-account';
    }
    else {
       id = 'dashboard';
    }
  } else {
     id = url.substring(url.lastIndexOf('#') + 1)
  }
  console.log('id ', id)

  // hide all tab panels
  tabPanels.forEach( tab => {
    tab.hidden = true
  });
  //mark all tab as unselected
  tabButtons.forEach((tab) => {
    tab.setAttribute('aria-selected', false);
  });
  //mark the clicked tab as unselected
  const s = document.getElementById(id);
  // console.log(s);
  s.setAttribute('aria-selected', true);
  const tabPanel = tabPanels.find(
    panel => panel.getAttribute('aria-labelledby') === id
  );
  tabPanel.hidden = false;
