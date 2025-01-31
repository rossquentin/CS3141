<%@ page import="com.greennit.CS3141.managers.PostManager" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="com.greennit.CS3141.entities.User" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.TimeZone" %>
<%@ page import="com.greennit.CS3141.managers.ThreadManager" %>
<%@ page import="com.greennit.CS3141.entities.Post" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">


    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Greenit</title>

    <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/view-thread.css" rel="stylesheet">

</head>

<body>

<script>
    function showPostBox(post) {
        document.getElementById("edit_post" + post).style.display = 'block';
    }

    function showThreadBox() {
        document.getElementById("edit_thread").style.display = 'block';
    }
</script>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">GREENNIT</a>
        <p class="text-warning">${message}</p>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive"
                aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp">Home
                        <span class="sr-only">(current)</span>
                    </a>
                    <c:if test="${empty user}">
                <li class="nav-item">
                    <a class="nav-link" href="login.jsp">Login</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="signup.jsp">Register</a>
                </li>
                </c:if>
                <c:if test="${not empty user}">
                    <li class="nav-item">
                        <a class="nav-link" href="create_thread.jsp">Create Thread</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="create_subgreennit.jsp">Create Subgreennit</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="account_details.jsp">${user.username}</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout">Logout</a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

<!-- Page Content -->
<div class="container">

    <div class="card">
        <div class="card-header">
            <!-- Thread Title -->
            <h1 class="my-4">${currentThread.title}</h1>
        </div>

        <div class="card-body">
            <!-- Thread Content -->
            <h4>${currentThread.content}</h4>
        </div>

        <%-- Displays the Author, Likes, and Time Posted --%>
        <div class="card-footer">
            <div class="row">
                <div class="col-2">
                    Author: <a href="view_profile?u=${currentThread.author}"
                               class="card-link">${currentThread.author} </a>
                </div>
                <div class="col-2">
                    Karma: ${postedBy.karma}
                </div>
                <div class="col-4">
                    Posted ${currentThread.timeAgo}
                </div>
                <div class="col-4">
                    g/${hostName}
                </div>

            </div>
            <div class="row">
                |
                <form action="${pageContext.request.contextPath}/thread_voting" id="threadLike" method="get">
                    <input type="hidden" name="username" value="${user.username}">
                    <input type="hidden" name="amount" value="1">
                    <input type="hidden" name="id" value="${currentThread.id}">

                    <button type="submit" class="btn btn-dark btn-sm" onclick="">^</button>
                </form>

                | ${currentThread.getLikes()} |

                <form action="${pageContext.request.contextPath}/thread_voting" id="threadDislike" method="get">
                    <input type="hidden" name="username" value="${user.username}">
                    <input type="hidden" name="amount" value="-1">
                    <input type="hidden" name="id" value="${currentThread.id}">

                    <button type="submit" class="btn btn-dark btn-sm" onclick="">v</button>
                </form>
                |
            </div>
            <c:if test="${currentThread.author.equals(user.username)}">
                <div class="row">
                    <div class="col-2">
                        <button type="button" id="edit_thread_button" class="btn btn-dark" onclick="showThreadBox()">
                            Edit Thread
                        </button>
                    </div>
                    <div class="col-2">
                        <form action="${pageContext.request.contextPath}/edit_threads" id="edit_thread"
                              style="display: none" method="get">
                            <input type="hidden" name="id" value="${currentThread.id}">

                            <label for="content">Enter new Content</label>
                            <input class="form-control" name="new_content" size="20" value="${currentThread.content}"/>

                            <button type="submit" class="btn btn-dark" onclick="">Submit</button>
                        </form>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- /.card -->
    <br>
    <div class="card">
        <div class="card-header">
            <h6>Comments: <a href="create_post.jsp" class="float-right">Comment on thread</a></h6>
        </div>
        <c:forEach items="${posts}" var="post">
            <br>
            <div class="card">
                <div class="card-body">
                    <p>${post.content}</p>
                </div>
                <div class="card-footer">
                    <div class="row">
                        <div class="col-2">
                            Author: <a href="view_profile?u=${post.author}" class="card-link">${post.author} </a>
                        </div>
                        <div class="col-4">
                            Posted ${post.timeAgo}
                        </div>
                        <div class="col-4">
                            g/${hostName}
                        </div>
                    </div>
                    <div class="row">
                        |
                        <form action="${pageContext.request.contextPath}/post_voting" id="postLike" method="get">
                            <input type="hidden" name="username" value="${user.username}">
                            <input type="hidden" name="postAmount" value="1">
                            <input type="hidden" name="postId" value="${post.id}">
                            <input type="hidden" name="threadId" value="${currentThread.id}">

                            <button type="submit" class="btn btn-dark btn-sm" onclick="">^</button>
                        </form>

                        | ${post.getLikes()} |

                        <form action="${pageContext.request.contextPath}/post_voting" id="postDislike" method="get">
                            <input type="hidden" name="username" value="${user.username}">
                            <input type="hidden" name="postAmount" value="-1">
                            <input type="hidden" name="postId" value="${post.id}">
                            <input type="hidden" name="threadId" value="${currentThread.id}">

                            <button type="submit" class="btn btn-dark btn-sm" onclick="">v</button>
                        </form>
                        |
                    </div>
                    <c:if test="${post.author.equals(user.username)}">
                    <div class="row">
                        <div class="col-2">
                            <button type="button" id="edit_post_button" class="btn btn-dark"
                                    onclick="showPostBox(${post.id})">Edit Post
                            </button>
                        </div>
                        <div class="col-2">
                            <form action="${pageContext.request.contextPath}/edit_posts" id="edit_post${post.id}"
                                  style="display: none" method="get">
                                <input type="hidden" name="post_id" value="${post.id}">
                                <input type="hidden" name="thread_id" value="${post.host_thread}">

                                <label for="content">Enter new Content</label>
                                <input class="form-control" name="new_content" size="20" value="${post.content}"/>

                                <button type="submit" class="btn btn-dark" onclick="">Submit</button>
                            </form>
                        </div>
                        </c:if>
                        <c:if test="${post.author.equals(user.username) || user.permission >= 2}">
                        <div class="col-2">
                            <form action="${pageContext.request.contextPath}/deletePosts" id="delete_post"
                                  method="get">
                                <input type="hidden" name="post_id" value="${post.id}">
                                <input type="hidden" name="thread_id" value="${post.host_thread}">
                                <button type="submit" class="btn btn-dark" onclick="">Delete Post</button>
                            </form>
                        </div>
                    </div>
                    </c:if>

                </div>
            </div>
        </c:forEach>
    </div>

</div>
<!-- /.container -->


<!-- Bootstrap core JavaScript -->
<script src="vendor/jquery/jquery.min.js"></script>
<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
        integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
        crossorigin="anonymous"></script>
</body>

</html>
