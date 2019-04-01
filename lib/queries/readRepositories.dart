String readRepositories = """
  query ReadRepositories {
    viewer {
      repositories{
        nodes {
          id
          name
          viewerHasStarred
        }
      }
    }
  }
"""
    .replaceAll('\n', ' ')
;
