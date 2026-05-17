#show: conf.with(
$if(title)$
  title: [$title$],
$endif$
$if(author)$
  author: (
    firstname: "$author.firstname$",
    lastname: "$author.lastname$",
    position: "$author.position$",
    address: "$author.address$",
    contacts: ($for(author.contacts)$(
      text: "$it.text$",
      url: "$it.url$",
      icon: "$it.icon$",
    )$sep$, $endfor$),
  ),
$endif$
)