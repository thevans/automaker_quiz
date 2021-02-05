class Answer {
    bool correct;
    int id;
    String title;

    Answer({this.correct, this.id, this.title});

    factory Answer.fromJson(Map<String, dynamic> json) {
        return Answer(
            correct: json['correct'], 
            id: json['id'], 
            title: json['title'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['correct'] = this.correct;
        data['id'] = this.id;
        data['title'] = this.title;
        return data;
    }
}