class Category {
  int id;
  String value;
  Category(String value, int id){
      this.value = value;
      this.id = id;
  }

  

  static List<Category> getCategories() {
    return <Category>[
        Category("Any Category",0),
         Category("General Knowledge", 9),
         Category("Books", 10),
         Category("Film", 11),
         Category("Music", 12),
         Category("Musicals & Theaters", 13),
         Category("Television", 14),
         Category("Video Games", 15),
         Category("Board Games", 16),
         Category("Science & Nature", 17),
         Category("Computers", 18),
         Category("Mathematics", 19),
         Category("Mythology", 20),
         Category("Sport", 21),
         Category("Geography", 22),
         Category("History", 23),
         Category("Politics", 24),
         Category("Art", 25),
         Category("Celebrities", 26),
         Category("Animals", 27),
         Category("Vehicles", 28),
         Category("Comics", 29),
         Category("Gadgets", 30),
         Category("Anime & Manga", 31),
         Category("Cartoon & Animations", 32),
    ];
  }
}
