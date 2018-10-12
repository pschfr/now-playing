# Used in development
debug = false

# Initiate timer variable
timer = ''

# Load scrobbles from Last.fm
lastFMrequest = () ->
    username = 'paul_r_schaefer'
    API_key = '0f680404e39c821cac34008cc4d803db'
    lastFM_URL = 'https://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=' + username + '&api_key=' + API_key + '&limit=1&format=json'
    xhr = new XMLHttpRequest()
    music = document.getElementById('music')
    image = document.getElementById('album')

    xhr.open('GET', lastFM_URL, true)
    xhr.onreadystatechange = () ->
        if (xhr.readyState == 4 && xhr.status == 200)
            # Decodes response from Last.fm
            track = JSON.parse(xhr.responseText).recenttracks.track[0]
            if debug
                console.log(track)
            url = track.url
            artist = track.artist['\#text']
            album = track.album['\#text']
            song = track.name
            # If image exists, use it, otherwise use blank image
            if track.image[0]['\#text']
                # This is an undocumented hack... Somehow this returns a larger image than possible otherwise
                # https://getmusicbee.com/forum/index.php?topic=22717.msg133539#msg133539
                imgURL = track.image[0]['\#text'].replace('34s', '_').replace('.png', '.jpg')
            else
                imgURL = "svg/notes.svg"

            # Add content to HTML
            image.src = imgURL
            image.alt = album
            image.title = album
            # If image as JPG doesn't load, try PNG version
            if image.complete = false
                imgURL = imgURL.replace('.jpg', '.png')
                image.src = imgURL
            music.innerHTML = '<a href="' + url + '" target="_blank" class="link underline-hover color-inherit">' + song + '<br><span class="f3 light-silver">' + artist + ' — ' + album + '</span></a>'

            # Changes page title
            document.title = song + ' — ' + artist

            # If the browser doesn't support backdrop-filter, append the image where neccessary for the fallback.
            if !CSS.supports('backdrop-filter: blur(1px)')
                # So it doesn't continously append to the CSS, only change the rule if the imgURL is different
                if document.styleSheets[0].cssRules[0].selectorText == 'html'
                    # Inserts the rule the first time
                    document.styleSheets[0].insertRule('body::before { background-image: url("' + imgURL + '") }')
                else
                    # Checks if the new image URL is different before replacing
                    if imgURL != document.styleSheets[0].cssRules[0].style.backgroundImage.replace('url("', '').replace('")', '')
                        document.styleSheets[0].cssRules[0].style.backgroundImage = 'url("' + imgURL + '")'
            # Otherwise, just append it to the body bg
            else
                document.body.style.backgroundImage = "url('" + imgURL + "')"
    xhr.send(null)

    timer = setTimeout(lastFMrequest, 5000) # refresh every 5 seconds

# On load, do this...
window.addEventListener 'load', () ->
    lastFMrequest()

# If tab is hidden, clear timer, or start it again
document.addEventListener 'visibilitychange', () ->
    if document.visibilityState == 'hidden'
        clearTimeout(timer)
    else if document.visibilityState == 'visible'
        lastFMrequest()
