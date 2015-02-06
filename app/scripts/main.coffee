apiURL = 'https://api.github.com/repos/yyx990803/vue/commits?per_page=3&sha='
isPhantom = navigator.userAgent.indexOf('PhantomJS') > -1

mocks = {
  master: [{sha:'111111111111', commit: {message:'one', author:{name:'Evan',date:'2014-10-15T13:52:58Z'}}},{sha:'111111111111', commit: {message:'hi', author:{name:'Evan',date:'2014-10-15T13:52:58Z'}}},{sha:'111111111111', commit: {message:'hi', author:{name:'Evan',date:'2014-10-15T13:52:58Z'}}}],
  dev: [{sha:'222222222222', commit: {message:'two', author:{name:'Evan',date:'2014-10-15T13:52:58Z'}}},{sha:'111111111111', commit: {message:'hi', author:{name:'Evan',date:'2014-10-15T13:52:58Z'}}},{sha:'111111111111', commit: {message:'hi', author:{name:'Evan',date:'2014-10-15T13:52:58Z'}}}],
  next: [{sha:'333333333333', commit: {message:'three', author:{name:'Evan',date:'2014-10-15T13:52:58Z'}}},{sha:'111111111111', commit: {message:'hi', author:{name:'Evan',date:'2014-10-15T13:52:58Z'}}},{sha:'111111111111', commit: {message:'hi', author:{name:'Evan',date:'2014-10-15T13:52:58Z'}}}]
}

mockData = ->
  this.commits = mocks[this.currentBranch]


demo = new Vue({
  el: '#demo'
  data: 
    branches: ['master', 'dev', 'next'],
    currentBranch: 'master',
    commits: null,
    message:'testmessage',
    disabled:false,
    n:0

  created: ->
    this.fetchData()
    this.$watch 'currentBranch', ->
      this.fetchData()
    
  filters: {
    truncate: (v) ->
      newline = v.indexOf('\n')
      if newline > 0 then v.slice(0, newline) else v  
    formatDate:(v) ->
      return v.replace(/T|Z/g, ' ')  
    reverse: (value)->
      value.split('').reverse().join('')
  }
  methods: {
    fetchData: ->
      if isPhantom
         mockData.call(this)
      xhr = new XMLHttpRequest()
      self = this
      xhr.open('GET', apiURL + self.currentBranch)
      xhr.onload = ->
        self.commits = JSON.parse(xhr.responseText)
      xhr.send()
    onClick: ->
      this.n++
  }
  directives:{
    disable: ->
      update: (value)->
        this.el.disabled = !!value
  }
})


