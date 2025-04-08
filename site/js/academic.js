document.addEventListener('DOMContentLoaded', function() {
  const navbarToggle = document.getElementById('navbar-toggle');
  const mainNav = document.getElementById('main-nav');
  
  if (navbarToggle && mainNav) {
      navbarToggle.addEventListener('click', function() {
          mainNav.classList.toggle('active');
      });
  }
  
  const bibtexToggle = document.querySelectorAll('.bibtex-toggle');
  
  bibtexToggle.forEach(function(toggle) {
      toggle.addEventListener('click', function() {
          const container = this.nextElementSibling;
          if (container && container.classList.contains('bibtex-container')) {
              container.classList.toggle('active');
          }
      });
  });
  
  initPublicationFilters();
  
  initTooltips();
});

function initPublicationFilters() {
  const publications = document.querySelectorAll('.publication-item');
  const yearFilter = document.getElementById('year-filter');
  const typeFilter = document.getElementById('type-filter');
  
  if (!yearFilter || !typeFilter || publications.length === 0) {
      return;
  }
  
  // Extract unique years
  const years = new Set();
  publications.forEach(pub => {
      if (pub.dataset.year) {
          years.add(pub.dataset.year);
      }
  });
  
  // Sort years in descending order
  const sortedYears = Array.from(years).sort((a, b) => b - a);
  
  // Add years to filter
  sortedYears.forEach(year => {
      const option = document.createElement('option');
      option.value = year;
      option.textContent = year;
      yearFilter.appendChild(option);
  });
  
  function filterPublications() {
      const selectedYear = yearFilter.value;
      const selectedType = typeFilter.value;
      
      publications.forEach(pub => {
          const yearMatch = selectedYear === 'all' || pub.dataset.year === selectedYear;
          const typeMatch = selectedType === 'all' || pub.dataset.type === selectedType;
          
          if (yearMatch && typeMatch) {
              pub.style.display = '';
          } else {
              pub.style.display = 'none';
          }
      });
  }
  
  yearFilter.addEventListener('change', filterPublications);
  typeFilter.addEventListener('change', filterPublications);
}

function initTooltips() {
  const tooltips = document.querySelectorAll('[data-tooltip]');
  
  tooltips.forEach(element => {
      element.addEventListener('mouseenter', function() {
          const tooltipText = this.getAttribute('data-tooltip');
          
          if (!tooltipText) return;
          
          const tooltip = document.createElement('div');
          tooltip.className = 'tooltip';
          tooltip.textContent = tooltipText;
          
          document.body.appendChild(tooltip);
          
          const rect = this.getBoundingClientRect();
          tooltip.style.top = rect.bottom + window.scrollY + 10 + 'px';
          tooltip.style.left = rect.left + window.scrollX + 'px';
          
          this.addEventListener('mouseleave', function onMouseLeave() {
              if (tooltip.parentNode) {
                  document.body.removeChild(tooltip);
              }
              this.removeEventListener('mouseleave', onMouseLeave);
          });
      });
  });
}