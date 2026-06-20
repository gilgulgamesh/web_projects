
















// ai

// pixel means the bottom of the page stays still, read more and the whole top move to keep that in place. makes sennse for scrolling up (thing willbe at the top)
        // marker means the top of the page stays still, and scroll the bottom up. makes sense for scrolling down.
        // dual does both but fails for scrolling down if the top marker isn't in the page. either way though it just feels unpredictable.'



        /// people will scroll down more than up. but, they'll feel claustrophobic when scrolling up. buttttt they'll have it at the bottom of the page always, so it's fine. when they're scrolling down, the read less being at the top wont ever bother them, and if it's at the bottm it'll please them. It's a yucky solution that works for the user 99% of the time... until they notice it.

        // pixel is nice in the way that it never advances the reader down, but never depends on screen position, always does the exact same thing

        //yeah pixel is the one, it makes the bottom of thepage feel solid, and the top stands on it. sits or stands. yeah it's nice scrolling down because you're looking at the next one which stays stil, and it's nice scrolling up because it folds the pge without jumping you up. yesssss and it's analagous to the top button. the top one stays i the same place too. ok.
        const cutoff = document.getElementById("posts")?.dataset.cutoff ?? 1000;
document.querySelectorAll(".Text").forEach(el => makeReadMore(el, cutoff, null));


        const blocktype = "nearest" // "top", bottom
        const scrollMode = "pixel"; // "dual", "marker", "pixel", or "none"
        function makeReadMore(element, text_cutoff, full) {
        if (!full) full = element.innerHTML;
        const text = element.textContent;

        if (text.length <= cutoff) return;
        let count = 0;
        let i = 0;
        while (i < full.length && count < cutoff) {
        if (full[i] === '<') {
        while (i < full.length && full[i] !== '>') i++;
        } else {
        count++;
        }
        i++;
        }

        //dfine collapsed
        const truncated = full.slice(0, i);

         //set read more button
        element.innerHTML = `
        ${truncated}<span class="cutoff-marker"></span><span class="ellipsis">... <a href="#" class="read-more-btn">more</a></span>
        <span class="full" hid den>${full}</span>
        `;
        element.querySelector(".read-more-btn").addEventListener("click", function(e) {
        e.preventDefault();
        element.innerHTML = full;

        // create top read less button
        const collapse = document.createElement("a");
        collapse.className = "readless-button-start";
        collapse.href = "#";
        collapse.innerHTML = "read less ⌄";
        collapse.addEventListener("click", function(e) {
        e.preventDefault();
        makeReadMore(element, cutoff, full);
        });
        element.prepend(collapse);

        //create bottom read less button
        const collapseEnd = document.createElement("a");
        collapseEnd.className = "readless-button-end";
        collapseEnd.href = "#";
        collapseEnd.innerHTML = "read less ⌃";
        collapseEnd.addEventListener("click", function(e) {
        e.preventDefault();
        const rect = collapseEnd.getBoundingClientRect();
        const endY = rect.top;
        makeReadMore(element, cutoff, full);
        if (scrollMode === "none") return;
        const marker = element.querySelector(".cutoff-marker");
        const markerRect = marker.getBoundingClientRect();
        if (scrollMode === "marker") {
        marker.scrollIntoView({ behavior: "smooth", block: blocktype });
        } else if (scrollMode === "pixel") {
        window.scrollBy({ top: markerRect.top - endY, behavior: "smooth", block: blocktype});
        } else if (scrollMode === "dual") {
        if (markerRect.top >= 0 && markerRect.top <= window.innerHeight) {
        marker.scrollIntoView({ behavior: "smooth", block: blocktype });
        } else {
        window.scrollBy({ top: markerRect.top - endY, behavior: "smooth" });
        }
        }

        });
        element.append(collapseEnd);
        });
        }
        document.querySelectorAll(".post-text").forEach(el => makeReadMore(el, text_cutoff, null));
