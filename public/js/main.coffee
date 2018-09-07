# Used in development
debug = false

# Load scrobbles from Last.fm
lastFMrequest = () ->
    username = 'paul_r_schaefer'
    API_key = '0f680404e39c821cac34008cc4d803db'
    lastFM_URL = 'https://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=' + username + '&api_key=' + API_key + '&limit=1&format=json'
    xhr = new XMLHttpRequest()
    music = document.getElementById('music')
    image = document.getElementById('image')

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
            if track.image[3]['\#text']
                # This is an undocumented hack... Somehow this returns a larger image than possible otherwise
                # https://getmusicbee.com/forum/index.php?topic=22717.msg133539#msg133539
                imgURL = track.image[3]['\#text'].replace('300x300', '_').replace('.png', '.jpg')
            else
                imgURL = "/svg/notes.svg"

            # Add content to HTML
            image.innerHTML = '<img src="' + imgURL + '" alt="' + album + '" title="' + album + '" class="vh-50 w-100">'
            music.innerHTML = '<p class="mb0"><a href="' + url + '" target="_blank" class="link underline-hover color-inherit">' + song + '<br><span class="f3 light-silver">' + artist + ' — ' + album + '</span></a></p>'

            # Changes page title
            document.title = song + ' — ' + artist

            # Sets body background image, later blurred with CSS
            document.body.style.backgroundImage = "url('" + imgURL + "')" 
    xhr.send(null)

    t = setTimeout(lastFMrequest, 5000) # refresh every 5 seconds

# On load, do this...
window.addEventListener 'load', () ->
    lastFMrequest()
