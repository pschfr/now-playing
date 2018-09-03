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
            track = JSON.parse(xhr.responseText).recenttracks.track[0]
            if debug
                console.log(track)
            url = track.url
            artist = track.artist['\#text']
            album = track.album['\#text']
            song = track.name
            if track.image[3]['\#text']
                imgURL = track.image[3]['\#text']
            else
                imgURL = "/svg/notes.svg"

            image.innerHTML = '<img src="' + imgURL + '" alt="' + album + '" title="' + album + '" class="h5 shadow-1">'
            music.innerHTML = '<p class="mb0"><a href="' + url + '" target="_blank" class="link underline-hover color-inherit">' + song + '<br><span class="f3 silver">' + artist + ' &mdash; ' + album + '</span></a></p>'
    xhr.send(null)

    t = setTimeout(lastFMrequest, 60000) # refresh every minute

# On load, do this...
window.addEventListener 'load', () ->
    lastFMrequest()
