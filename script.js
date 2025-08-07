// Utility function to copy code to clipboard
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
        // Show success feedback
        const notification = document.createElement('div');
        notification.className = 'alert alert-success';
        notification.style.position = 'fixed';
        notification.style.bottom = '20px';
        notification.style.right = '20px';
        notification.style.zIndex = '1000';
        notification.textContent = '✓ Código copiado al portapapeles';
        document.body.appendChild(notification);
        
        setTimeout(() => notification.remove(), 2000);
    });
}

// Initialize copy buttons for code blocks
function initializeCodeBlocks() {
    document.querySelectorAll('pre').forEach(block => {
        // Wrap in container
        const container = document.createElement('div');
        container.className = 'code-block';
        block.parentNode.insertBefore(container, block);
        container.appendChild(block);

        // Add copy button
        const button = document.createElement('button');
        button.className = 'copy-button';
        button.textContent = 'Copiar';
        button.onclick = () => copyToClipboard(block.textContent);
        container.appendChild(button);
    });
}

// Progress tracking
function updateProgress() {
    const sections = document.querySelectorAll('section[id]');
    const progressItems = document.querySelectorAll('.progress-item');
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const index = Array.from(sections).indexOf(entry.target);
                progressItems.forEach((item, i) => {
                    item.classList.toggle('active', i === index);
                });
            }
        });
    }, { threshold: 0.5 });

    sections.forEach(section => observer.observe(section));
}

// Table of contents generator
function generateTOC() {
    const content = document.querySelector('.main-content');
    const sidebar = document.querySelector('.sidebar');
    
    if (!content || !sidebar) return;

    const headings = content.querySelectorAll('h2, h3');
    const nav = document.createElement('nav');
    nav.className = 'page-nav';
    const list = document.createElement('ul');

    headings.forEach(heading => {
        const id = heading.id || heading.textContent.toLowerCase().replace(/\s+/g, '-');
        heading.id = id;

        const item = document.createElement('li');
        const link = document.createElement('a');
        link.href = `#${id}`;
        link.textContent = heading.textContent;
        link.className = heading.tagName === 'H3' ? 'sub-item' : '';
        
        item.appendChild(link);
        list.appendChild(item);

        // Highlight current section
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                link.classList.toggle('active', entry.isIntersecting);
            });
        }, { threshold: 0.5 });

        observer.observe(heading);
    });

    nav.appendChild(list);
    sidebar.appendChild(nav);
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    initializeCodeBlocks();
    generateTOC();
    updateProgress();
});

// Handle mobile navigation
const mobileNavToggle = document.querySelector('.mobile-nav-toggle');
if (mobileNavToggle) {
    mobileNavToggle.addEventListener('click', () => {
        document.querySelector('.nav-links').classList.toggle('active');
    });
}

// Smooth scroll for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', (e) => {
        e.preventDefault();
        const target = document.querySelector(anchor.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth'
            });
        }
    });
});
