---
title: blahaj.bio
published: 2025-04-16
description: 'Building a clean, modern bio creation website with accessibility in mind'
image: ''
tags: [yapping, project, web-development]
category: 'projects'
draft: false
lang: 'en'
---

::github{repo="nobleskye/blahaj.bio"}
---

# Prologue of blahaj.bio

I own a lot of domain names - probably more than I should admit - and [pronouns.site](https://pronouns.site) is one of the ones I recently decided to actually put to good use. The domain name itself was too perfect to pass up: Pronouns.site ends with `.site` as the TLD, so creating a pronouns information website felt like the most natural fit. It's a simple concept, but I hadn't tackled a project quite like this before, so I thought it would be a fun challenge to dive into.

The goal was straightforward: create a simple, clean bio creation website that anyone could use to build their own personal bio page. But I had a specific audience in mind - primarily people in the LGBTQ+ community. This demographic tends to be more interested in creating personalized bio pages for social media profiles, Discord servers, and other online spaces where self-expression matters. Plus, they're the ones most likely to recognize and appreciate Blähaj, the adorable shark plushie from IKEA that has somehow become an unofficial mascot for trans and queer communities.

Going into this project, I had never worked extensively with GitHub Actions for automation. The learning curve was definitely steeper than I expected, but that's what made it interesting. With some persistence and help from a few developer friends, I managed to create a workflow that would become the heart of the entire project.

---

# The Technical Foundation: Why Astro?

When I started building the website, I wanted to keep things simple while still delivering a modern, fast experience. I decided to use [Astro](https://astro.build/), a static site generator I'd been seeing in other projects and wanted to try hands-on. Astro caught my attention because of its focus on performance and simplicity - it generates static HTML by default and only loads JavaScript when absolutely necessary.

What really sold me on Astro was its component-based structure. You can create components and pages that are reusable with minimal setup, and it plays nicely with multiple frameworks if you need them. For a project like blahaj.bio, where the core functionality is relatively straightforward, Astro's "islands architecture" meant I could build a lightning-fast site without unnecessary complexity.

The framework also handles content collections beautifully, which was perfect for my vision of treating each bio as a structured piece of content - similar to how blog posts work, but for personal profiles instead.d

---

# Designing the User Experience

Before diving into the GitHub Actions workflow, I needed to nail down exactly how users would interact with the site. I drew inspiration from how GitHub Pages works with Jekyll - users write content in Markdown files with frontmatter containing metadata, and the site generator handles the rest.

For blahaj.bio, I designed a bio format that would include:
- **Username**: The unique identifier that becomes part of their URL
- **Display Name**: How they want to be presented on their bio page
- **Pronouns**: Essential for inclusive representation
- **Bio Content**: A free-form section where users can write about themselves, their interests, links, etc.
- **Links**: A section for social media or other relevant URLs

```markdown
---
username: ""
display_name: ""
pronouns: ""
bio: |
  
links: |
  
---
```
---


The beauty of this approach is that users don't need to know HTML, CSS, or any web development. They just fill out a structured format, and the site handles all the styling and presentation automatically. And that all the user has to do is create a GitHub issue and choose `create bio` as the template then fill out the fourm. And once they submit, their bio is live within minutes. (whenever github actions run & sucessfully builds the site)

--- 

# The GitHub Actions Magic

Here's where things got really interesting. I wanted to create a workflow that would be as frictionless as possible for users. The solution I settled on was to leverage GitHub Issues as the interface for bio creation.

## The Workflow Process

1. **User Creates an Issue**: Users visit the GitHub repository and create a new issue using a predefined template that includes all the bio fields
2. **Automated Processing**: A GitHub Action triggers when an issue is created with the correct label, parses the content, and extracts the bio information
3. **File Generation**: The workflow creates a new Markdown file in `src/content/bios/` with the user's information
4. **Site Build & Deploy**: Astro builds the updated site and deploys it to GitHub Pages automatically
5. **User Notification**: The user gets notified that their bio is live at `blahaj.bio/username` within the issue and can share it with others

This approach means users never have to:
- Fork repositories
- Create pull requests
- Understand Git workflows
- Deal with merge conflicts
- Wait for manual approval

They just create an issue, and within a few minutes, they have a live bio page.

## Technical Challenges

Getting the GitHub Actions workflow right took several iterations. Some of the key challenges I had to solve:

**Parsing Issue Content**: I needed to reliably extract structured data from free-form issue text. I used regex patterns and YAML parsing to handle the frontmatter-style format.

**Error Handling**: What happens if someone submits malformed data? I added validation steps and automated comments to guide users through fixing issues.

**Security**: Since this processes user-generated content, I had to be careful about sanitization and preventing malicious input from affecting the build process. Luckily, because the site is in markdown format it never actually runs any code, so the risk is minimal. But I still implemented basic checks to ensure no harmful content could slip through. Even tho some users had tried to submit things like `javascript:alert('hello')` in their bios, which was caught when I was first sharing the project with friends for them to test out the site.

**Rate Limiting**: GitHub has limits on Actions usage, so I implemented smart triggering to only run the workflow for properly labeled issues.

---

# Building the Site Architecture

The Astro site itself is structured to handle dynamic bio pages efficiently. Here's how I organized it:

## Content Structure
```
src/
├── content/
│   ├── config.ts          # Content collection definitions
│   └── bios/              # Individual bio files
│       ├── username1.md
│       ├── username2.md
│       └── ...
├── components/
│   ├── BioCard.astro      # Individual bio display
│   ├── BioGrid.astro      # Grid of bio previews
│   └── Layout.astro       # Base page layout
├── pages/
│   ├── index.astro        # Homepage with bio grid
│   ├── [username].astro   # Dynamic bio pages
│   └── about.astro        # Project information
└── styles/
    └── global.css         # Blahaj-themed styling
```

## Dynamic Routing

Astro's file-based routing made it easy to create dynamic pages for each bio. The `[username].astro` file automatically generates a page for every bio in the content collection, accessible at `blahaj.bio/username`.

## Design Philosophy

I wanted the visual design to be:
- **Clean and readable**: Focus on content, not flashy UI
- **Blahaj-themed**: Soft blues and whites reminiscent of the beloved shark
- **Accessible**: High contrast, semantic HTML, keyboard navigation
- **Mobile-friendly**: Responsive design that works on any device

---

# Community Response and Iteration

Since launching blahaj.bio, the response from the community has been really encouraging. I've seen people create bios for everything from personal introductions to project showcases to creative portfolios.

## What I've Learned

**Simplicity is powerful**: By removing technical barriers, more people feel comfortable creating and sharing their bios.

**Community matters**: The LGBTQ+ community really embraced the project, and seeing people use it for self-expression has been incredibly rewarding.

**Automation enables creativity**: When the technical process is automated, users can focus entirely on crafting their content.

## Future Improvements

I'm considering several enhancements:
- **Custom themes**: Let users choose different color schemes or layouts
- **Bio templates**: Predefined formats for different use cases (professional, creative, gaming, etc.)
- **Better moderation**: Tools to handle inappropriate content more effectively
- **Analytics**: Basic insights for bio creators (views, etc.)
- **Export options**: Allow users to download their bio in different formats

---

# The Technical Stack in Detail

For anyone interested in the technical implementation:

**Frontend**: Astro with TypeScript for type safety
**Styling**: Vanilla CSS with CSS custom properties for theming
**Content**: Markdown with YAML frontmatter, processed by Astro's content collections
**Automation**: GitHub Actions with running on every issue with the `bio-creation` label that is marked open to rebuild the website
**Hosting**: GitHub Pages with custom domain
**Monitoring**: GitHub's built-in insights and Actions logs

The entire project is open source, so anyone can contribute improvements or fork it for their own use cases.

---

# Reflections on the Project

Building blahaj.bio taught me a lot about creating frictionless user experiences and the power of automation. It's one thing to build a tool for developers who understand Git workflows; it's another to create something that anyone can use regardless of their technical background.

Most importantly, it's been a joy to see people use the platform to express themselves. There's something special about providing a simple tool that enables creativity and self-expression, even in small ways. Although the look of the site is still very simple and needs more updates to make it more visually appealing, the core functionality is solid and serves its purpose well.

---

# Getting Started

If you want to try it out, just head over to the [blahaj.bio GitHub repository](https://github.com/nobleskye/blahaj.bio), create a new issue with the bio template, and you'll have your own bio page within minutes. It's free, it's simple, and it's made with love for the community.

And if you're a developer interested in contributing or creating something similar, all the code is available to explore, fork, and improve upon. Sometimes the best projects are the ones that solve simple problems in delightful ways.

🦈💙



