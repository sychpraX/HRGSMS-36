from fastapi import FastAPI
from fastapi.params import Body
from pydantic import BaseModel


app = FastAPI()

#The data that will be in the database is hardcoded
my_posts = [{"title":"my life", "content": "Vlog on ky day to day work", "id":1}, {"title": "my dog", "content":"Its a dashchund", "id":2}, ]

class Post(BaseModel):
    title: str
    content: str

@app.get("/")
def root():
    return {"message": "Hello, World"}

#Retrieve in CRUD
@app.get("/posts")
def get_posts():
    return my_posts

#Create in CRUD
@app.post("/posts")
def create_post(post: Post):
    post_dict = post.dict()
    post_dict["id"] = 123
    my_posts.append(post_dict)
    return my_posts



