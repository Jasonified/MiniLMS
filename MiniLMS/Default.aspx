<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MiniLMS.Landing" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <meta name="description" content="MiniLMS is a learning management system for students, instructors and administrators." />
    <title>MiniLMS | Learning Management System</title>
    <style>
        :root {
            --teal: #153f73;
            --navy: #102e52;
            --blue: #1d63b5;
            --muted: #647785;
            --line: #dce6f3
        }

        * {
            box-sizing: border-box
        }

        html {
            scroll-behavior: smooth;
            scroll-padding-top: 90px
        }

        body {
            margin: 0;
            background: #fff;
            color: #203b5c;
            font-family: 'Segoe UI',Arial,sans-serif;
            line-height: 1.65
        }

        a {
            text-decoration: none;
            color: inherit
        }

            a:focus-visible {
                outline: 3px solid #78aaf0;
                outline-offset: 3px
            }

        .wrap {
            width: min(1160px,calc(100% - 48px));
            margin: auto
        }

        .header {
            background: #fff;
            border-bottom: 1px solid #e6edf6;
            position: sticky;
            top: 0;
            z-index: 30
        }

        .header-inner {
            min-height: 83px;
            display: flex;
            align-items: center;
            gap: 26px
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 11px;
            flex-shrink: 0
        }

        .brand-mark {
            display: grid;
            place-items: center;
            background: #153f73;
            color: white;
            font-size: 24px;
            font-weight: 800;
            width: 45px;
            height: 45px
        }

        .brand strong {
            font-size: 22px;
            letter-spacing: -.7px;
            color: #14365f;
            display: block;
            line-height: 1.1
        }

        .brand small {
            font-size: 10px;
            color: #61758d;
            display: block
        }

        .nav {
            margin-left: auto;
            display: flex;
            align-items: center;
            gap: 28px
        }

            .nav a {
                font-size: 12px;
                font-weight: 700;
                letter-spacing: .35px;
                color: #536c89
            }

                .nav a:hover, .nav a:first-child {
                    color: var(--teal)
                }

        .nav-auth {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-left: 10px
        }

            .nav-auth a {
                font-size: 13px;
                font-weight: 700;
                border-radius: 5px;
                padding: 10px 17px;
                white-space: nowrap
            }

            .nav-auth .signin {
                color: var(--teal);
                border: 1px solid #b9cde7
            }

            .nav-auth .signup {
                background: var(--teal);
                color: white
            }

            .nav-auth a:hover {
                filter: brightness(.94)
            }

        .hero {
            background: #fff;
            overflow: hidden
        }

        .hero-inner {
            min-height: 570px;
            display: grid;
            grid-template-columns: .85fr 1.15fr;
            gap: 40px;
            align-items: center;
            padding: 56px 0 62px
        }

        .hero-copy {
            max-width: 485px
        }

        .eyebrow {
            color: #2e6bb1;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 2.3px;
            text-transform: uppercase
        }

        .hero h1 {
            font-size: clamp(38px,4.4vw,62px);
            line-height: 1.07;
            letter-spacing: -2.3px;
            color: var(--teal);
            margin: 17px 0 23px
        }

        .hero p {
            font-size: 15px;
            line-height: 1.85;
            color: #64758a;
            max-width: 440px;
            margin: 0 0 27px
        }

        .button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: 750;
            font-size: 13px;
            transition: transform .2s,background .2s
        }

            .button:hover {
                transform: translateY(-2px)
            }

        .button-primary {
            background: var(--teal);
            color: white
        }

        .button-outline {
            border: 1px solid #b8cce5;
            color: var(--teal);
            background: white
        }

        .hero-links {
            display: flex;
            gap: 12px;
            flex-wrap: wrap
        }

        .hero-art {
            width: 100%;
            max-width: 630px;
            margin: auto
        }

            .hero-art svg {
                display: block;
                width: 100%;
                height: auto
            }

        .section {
            padding: 76px 0
        }

            .section.alt {
                background: #f3f7fd
            }

        .section-head {
            text-align: center;
            max-width: 710px;
            margin: 0 auto 36px
        }

        .overline {
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: var(--teal)
        }

        .section-head h2 {
            font-size: clamp(26px,3vw,37px);
            color: #153a68;
            line-height: 1.25;
            margin: 11px 0
        }

        .section-head p {
            color: var(--muted);
            font-size: 14px;
            margin: 0
        }

        .feature-grid, .role-grid {
            display: grid;
            grid-template-columns: repeat(3,minmax(0,1fr));
            gap: 20px
        }

        .feature-card, .role-card {
            background: white;
            border: 1px solid var(--line);
            padding: 26px;
            border-radius: 10px;
            box-shadow: 0 12px 25px #153f7312
        }

        .feature-symbol {
            height: 52px;
            width: 52px;
            display: grid;
            place-items: center;
            background: #e6f0fd;
            border-radius: 12px;
            color: var(--teal);
            font-size: 23px;
            margin-bottom: 15px
        }

        .feature-card h3, .role-card h3 {
            color: #163b6a;
            font-size: 18px;
            margin: 0 0 8px
        }

        .feature-card p, .role-card p {
            color: var(--muted);
            font-size: 14px;
            margin: 0
        }

        .role-card {
            border-top: 4px solid var(--teal)
        }

        .role-icon {
            font-size: 29px;
            margin-bottom: 10px
        }

        .role-card ul {
            color: #536b87;
            padding-left: 20px;
            font-size: 13px;
            margin: 12px 0 0
        }

        .role-card li {
            margin: 6px 0
        }

        .workflow {
            display: grid;
            grid-template-columns: repeat(3,1fr);
            gap: 23px
        }

        .step {
            display: flex;
            align-items: flex-start;
            gap: 15px
        }

        .step-number {
            display: grid;
            place-items: center;
            flex-shrink: 0;
            width: 39px;
            height: 39px;
            border-radius: 50%;
            background: var(--teal);
            color: white;
            font-weight: 800
        }

        .step h3 {
            margin: 0 0 5px;
            color: #163b6a
        }

        .step p {
            margin: 0;
            color: var(--muted);
            font-size: 13px
        }

        .access {
            background: #eaf2fc;
            padding: 55px 0
        }

        .access-inner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 25px
        }

        .access h2 {
            color: #163b6a;
            font-size: 27px;
            margin: 0 0 7px
        }

        .access p {
            color: #536b87;
            margin: 0;
            max-width: 630px
        }

        .access .button {
            background: var(--teal);
            color: #fff
        }

        .footer {
            background: #102e52;
            color: #dce9f8;
            padding: 30px 0
        }

        .footer-inner {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px
        }

        .footer strong {
            color: #fff;
            font-size: 20px
        }

        .footer p {
            margin: 2px 0 0;
            font-size: 12px
        }

        .footer-links {
            display: flex;
            gap: 17px;
            font-size: 12px
        }

            .footer-links a:hover {
                text-decoration: underline
            }

        @media(max-width:1000px) {
            .header-inner {
                flex-wrap: wrap;
                padding: 12px 0
            }

            .nav {
                order: 3;
                width: 100%;
                justify-content: center;
                margin: 0;
                gap: 20px
            }

            .nav-auth {
                margin-left: auto
            }

            .hero-inner {
                grid-template-columns: 1fr 1fr;
                gap: 20px
            }

            .hero h1 {
                font-size: 42px
            }
        }

        @media(max-width:700px) {
            .wrap {
                width: calc(100% - 32px)
            }

            .nav {
                overflow-x: auto;
                justify-content: flex-start;
                gap: 20px
            }

                .nav a {
                    white-space: nowrap
                }

            .nav-auth a {
                padding: 8px 12px
            }

            .brand small {
                display: none
            }

            .hero-inner {
                grid-template-columns: 1fr;
                padding: 48px 0 30px;
                min-height: auto
            }

            .hero-copy {
                max-width: 100%
            }

            .hero h1 {
                font-size: 42px
            }

            .hero-art {
                max-width: 500px
            }

            .feature-grid, .role-grid, .workflow {
                grid-template-columns: 1fr
            }

            .section {
                padding: 53px 0
            }

            .access-inner, .footer-inner {
                flex-direction: column;
                align-items: flex-start
            }

            .footer-links {
                flex-wrap: wrap
            }
        }

        @media(prefers-reduced-motion:reduce) {
            html {
                scroll-behavior: auto
            }

            .button {
                transition: none
            }
        }

        .anchor-target {
            display: block;
            position: relative;
            top: -90px;
            visibility: hidden
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <header class="header">
            <div class="wrap header-inner"><a href="#home" class="brand" aria-label="MiniLMS Home"><span class="brand-mark">M</span><span><strong>MiniLMS</strong><small>Learning Management System</small></span></a><nav class="nav" aria-label="Main navigation"><a href="#home">HOME</a><a href="#about">ABOUT</a><a href="#features">FEATURES</a><a href="#roles">USER ROLES</a><a href="#how-it-works">HOW IT WORKS</a></nav>
                <div class="nav-auth"><a class="signin" href='<%= ResolveUrl("~/Account/Login.aspx") %>'>Sign In</a><a class="signup" href='<%= ResolveUrl("~/Account/Register.aspx") %>'>Sign Up</a></div>
            </div>
        </header>
        <main>
            <section class="hero" id="home">
                <div class="wrap hero-inner">
                    <div class="hero-copy"><span class="eyebrow">WELCOME TO MINILMS</span><h1>Learning Management System</h1>
                        <p>A shared academic space for students, instructors, and administrators. Manage courses, organize lessons, submit assignments, and support learning—all in one place.</p>
                        <div class="hero-links"><a class="button button-primary" href='<%= ResolveUrl("~/Account/Login.aspx") %>'>EXPLORE MINILMS →</a><a class="button button-outline" href="#features">LEARN MORE</a></div>
                    </div>
                    <div class="hero-art">
                        <svg viewBox="0 0 590 500" role="img" aria-label="Illustration of connected learning, teaching, course management, and assessment" xmlns="http://www.w3.org/2000/svg">
                            <defs>
                                <linearGradient id="mint" x1="0" y1="0" x2="1" y2="1">
                                    <stop stop-color="#dcecff" />
                                    <stop offset="1" stop-color="#f0f6ff" />
                                </linearGradient>
                            </defs>
                            <circle cx="302" cy="250" r="194" fill="none" stroke="#d6e4f6" stroke-width="2" stroke-dasharray="7 10" />
                            <circle cx="302" cy="250" r="153" fill="url(#mint)" opacity=".7" />
                            <g stroke="#8db8e7" stroke-width="3" fill="none" stroke-linecap="round">
                                <path d="M302 102V174L230 209M302 174L389 209M230 209L194 302M389 209L430 307M194 302L294 365L430 307M302 174L294 365" />
                            </g>
                            <g fill="#fff" stroke="#bbd4f0" stroke-width="2">
                                <rect x="249" y="167" width="107" height="73" rx="9" />
                                <rect x="105" y="271" width="126" height="88" rx="9" />
                                <rect x="371" y="270" width="128" height="88" rx="9" />
                                <rect x="233" y="337" width="122" height="92" rx="9" />
                            </g>
                            <rect x="259" y="177" width="87" height="14" rx="4" fill="#276fac" />
                            <rect x="260" y="202" width="34" height="24" rx="3" fill="#d7e8fb" />
                            <path d="M302 207h34m-34 9h26" stroke="#93b5de" stroke-width="4" stroke-linecap="round" />
                            <path d="M125 291h86v51h-86z" fill="#eaf3fe" />
                            <path d="M132 303h71m-71 11h54m-54 11h61" stroke="#2b78bd" stroke-width="5" stroke-linecap="round" />
                            <rect x="390" y="288" width="90" height="52" rx="4" fill="#eaf3fe" />
                            <path d="M403 303l13 12 24-23" stroke="#3f80c3" stroke-width="6" fill="none" stroke-linecap="round" />
                            <path d="M446 303h23m-23 13h17" stroke="#6c9ed5" stroke-width="4" />
                            <path d="M253 355h83v54h-83z" fill="#eaf3fe" />
                            <path d="M265 371h60m-60 11h48m-48 11h37" stroke="#4c90d0" stroke-width="5" stroke-linecap="round" />
                            <g fill="#fff" stroke="#276fac" stroke-width="3">
                                <circle cx="302" cy="103" r="36" />
                                <circle cx="158" cy="174" r="31" />
                                <circle cx="446" cy="165" r="31" />
                            </g>
                            <g stroke="#4c8acb" stroke-width="5" fill="none" stroke-linecap="round">
                                <path d="M287 99l15-8 15 8-15 8zM291 106v12q11 10 22 0v-12" />
                                <path d="M146 164h24v19h-24zM150 160h16M152 171h13" />
                                <path d="M436 157h20v19h-20zM446 152v29" />
                            </g>
                            <g fill="#4c8acb">
                                <circle cx="202" cy="102" r="5" />
                                <circle cx="415" cy="102" r="5" />
                                <circle cx="85" cy="230" r="5" />
                                <circle cx="514" cy="234" r="5" />
                            </g>
                            <g stroke="#4c8acb" stroke-width="3" fill="none">
                                <path d="M185 88l10-10m-5 22h-14M483 107l11-11m-8 20h15M75 379l12-12m-4 21h16M509 395l-12-12m4 22h-16" />
                            </g>
                            <g fill="#fff" stroke="#9ec3ee" stroke-width="2">
                                <rect x="90" y="105" width="55" height="43" rx="5" />
                                <rect x="454" y="383" width="55" height="43" rx="5" />
                            </g><path d="M101 117h32m-32 9h23m-23 9h29M464 397h34m-34 10h24" stroke="#2b73b7" stroke-width="4" stroke-linecap="round" />
                            <text x="302" y="470" text-anchor="middle" font-size="14" font-family="Segoe UI,Arial" fill="#245b9b">LEARN  •  TEACH  •  MANAGE</text>
                        </svg>
                    </div>
                </div>
            </section>
            <span id="about" class="anchor-target"></span>
            <section class="section alt" id="features">
                <div class="wrap">
                    <div class="section-head"><span class="overline">Platform features</span><h2>Tools That Support the Learning Process</h2>
                        <p>Core MiniLMS features are organized around the responsibilities of each user.</p>
                    </div>
                    <div class="feature-grid">
                        <article class="feature-card">
                            <div class="feature-symbol">♙</div>
                            <h3>User Management</h3>
                            <p>Manage account approval, user roles, and access to the system.</p>
                        </article>
                        <article class="feature-card">
                            <div class="feature-symbol">▣</div>
                            <h3>Course Assignment</h3>
                            <p>Administrators assign existing courses to instructors and students.</p>
                        </article>
                        <article class="feature-card">
                            <div class="feature-symbol">▤</div>
                            <h3>Course Content</h3>
                            <p>Instructors manage modules, lessons, and materials for assigned courses.</p>
                        </article>
                        <article class="feature-card">
                            <div class="feature-symbol">▥</div>
                            <h3>Learning Materials</h3>
                            <p>Students access course content and download available lesson files.</p>
                        </article>
                        <article class="feature-card">
                            <div class="feature-symbol">✎</div>
                            <h3>Assignment Submission</h3>
                            <p>Students submit coursework through their assigned courses.</p>
                        </article>
                        <article class="feature-card">
                            <div class="feature-symbol">★</div>
                            <h3>Grades &amp; Feedback</h3>
                            <p>Instructors assess submissions and students review their results.</p>
                        </article>
                    </div>
                </div>
            </section>
            <section class="section" id="roles">
                <div class="wrap">
                    <div class="section-head"><span class="overline">Who uses MiniLMS?</span><h2>Designed for the Academic Community</h2>
                        <p>Each role has a dedicated workspace and the tools needed for its responsibilities.</p>
                    </div>
                    <div class="role-grid">
                        <article class="role-card">
                            <div class="role-icon" aria-hidden="true">🎓</div>
                            <h3>Students</h3>
                            <p>Access assigned courses and complete learning activities.</p>
                            <ul>
                                <li>View modules and lessons</li>
                                <li>Download learning materials</li>
                                <li>Submit assignments and view feedback</li>
                            </ul>
                        </article>
                        <article class="role-card">
                            <div class="role-icon" aria-hidden="true">📚</div>
                            <h3>Instructors</h3>
                            <p>Prepare and manage the learning experience for assigned courses.</p>
                            <ul>
                                <li>Organize modules and lessons</li>
                                <li>Publish assigned courses</li>
                                <li>Review, grade, and provide feedback</li>
                            </ul>
                        </article>
                        <article class="role-card">
                            <div class="role-icon" aria-hidden="true">⚙</div>
                            <h3>Administrators</h3>
                            <p>Oversee accounts, course records, and academic assignments.</p>
                            <ul>
                                <li>Approve and manage user accounts</li>
                                <li>Maintain course information</li>
                                <li>Assign courses to instructors and students</li>
                            </ul>
                        </article>
                    </div>
                </div>
            </section>
            <section class="section alt" id="how-it-works">
                <div class="wrap">
                    <div class="section-head"><span class="overline">How MiniLMS works</span><h2>A Simple, Organized Workflow</h2>
                        <p>Course access and learning activities follow a clear role-based process.</p>
                    </div>
                    <div class="workflow">
                        <div class="step"><span class="step-number">1</span><div>
                            <h3>Administration</h3>
                            <p>The administrator manages accounts, maintains courses, and assigns them to users.</p>
                        </div>
                        </div>
                        <div class="step"><span class="step-number">2</span><div>
                            <h3>Course Preparation</h3>
                            <p>Instructors add learning content and assignments to their assigned courses.</p>
                        </div>
                        </div>
                        <div class="step"><span class="step-number">3</span><div>
                            <h3>Learning &amp; Assessment</h3>
                            <p>Students access assigned courses, submit work, and receive grades and feedback.</p>
                        </div>
                        </div>
                    </div>
                </div>
            </section>
            <section class="access" id="access">
                <div class="wrap access-inner">
                    <div>
                        <h2>Access Your MiniLMS Account</h2>
                        <p>Log in to continue to your role-based workspace. New student accounts require administrator approval before access is granted.</p>
                    </div>
                    <a class="button" href='<%= ResolveUrl("~/Account/Login.aspx") %>'>Log In to MiniLMS →</a></div>
            </section>
        </main>
        <footer class="footer">
            <div class="wrap footer-inner">
                <div><strong>MiniLMS</strong><p>Learning Management System &nbsp; | &nbsp; © <%= DateTime.Now.Year %> MiniLMS</p>
                </div>
                <div class="footer-links"><a href="#home">Home</a><a href="#about">About</a><a href="#features">Features</a><a href='<%= ResolveUrl("~/Account/Login.aspx") %>'>Log In</a><a href='<%= ResolveUrl("~/Account/Register.aspx") %>'>Register</a></div>
            </div>
        </footer>
        </main>
    </form>
</body>
</html>
