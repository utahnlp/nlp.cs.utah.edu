document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('pub-search');
    if (!searchInput) return;
    searchInput.addEventListener('input', (e) => {
        const term = e.target.value.toLowerCase();
        const years = document.querySelectorAll('.pub-year-section');
        years.forEach(yearSection => {
            let hasVisiblePubs = false;
            const pubs = yearSection.querySelectorAll('.pub-item');
            pubs.forEach(pub => {
                const text = pub.innerText.toLowerCase();
                const isMatch = text.includes(term);
                pub.classList.toggle('d-none', !isMatch);
                if (isMatch) hasVisiblePubs = true;
            });
            yearSection.classList.toggle('d-none', !hasVisiblePubs);
        });
    });
});