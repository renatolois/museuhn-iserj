function load_pdf(url) {
    const container = document.getElementById('pdf-container');
    pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.4.120/pdf.worker.min.js';
    pdfjsLib.getDocument(url).promise.then(pdf => {
    for (let pageNumber = 1; pageNumber <= pdf.numPages; pageNumber++) {
        pdf.getPage(pageNumber).then(page => {
        const viewport = page.getViewport({ scale: 2 });
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        canvas.width = viewport.width;
        canvas.height = viewport.height;
        container.appendChild(canvas);
        page.render({
            canvasContext: ctx,
            viewport: viewport
            });
        });
    }
    }).catch(err => {
        console.error("Error loading PDF:", err);
    });
}