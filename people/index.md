---
layout: default
title: People
---

<div class="container py-4">
    <h1 class="mb-4 display-5 fw-bold">Utah NLP People</h1>

    <section class="mb-5">
        <h2 class="border-bottom pb-2 mb-4">Faculty</h2>
        {% make_people who:faculty %}
    </section>

    <section class="mb-5">
        <h2 class="border-bottom pb-2 mb-4">Doctoral Students</h2>
        {% make_people who:graduates degree:PhD %}
    </section>

    <!-- <section class="mb-5">
        <h2 class="border-bottom pb-2 mb-4">Master's Students</h2>
        {% make_people who:graduates degree:MS %}
    </section> -->

    <section class="mb-5">
        <h2 class="border-bottom pb-2 mb-4">Undergraduate Students</h2>
        {% make_people who:undergraduates %}
    </section>

    <section class="mb-5">
        <h2 class="border-bottom pb-2 mb-4">Former Members</h2>
        {% make_people who:alumni %}
    </section>
</div>