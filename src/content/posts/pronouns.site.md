---
title: pronouns.site
published: 2025-04-16
description: 'Building a comprehensive pronoun education platform with Next.js and modern web technologies'
image: ''
tags: [yapping, project, web-development]
category: 'projects'
draft: false
lang: 'en'
---

::github{repo="nobleskye/pronouns.site"}
---

# Prologue of Pronouns.site

I own way too many domain names - it's honestly becoming a problem at this point. But when I saw `pronouns.site` available, I couldn't resist. The domain name was just too perfect.

At first, I thought this would be another quick weekend project. But as I started researching existing pronoun resources, I realized most were either outdated, hard to navigate, or lacking the comprehensive examples that people actually need. This wasn't going to be just another static site - it needed to be something genuinely useful.

The goal became clear: create the most comprehensive, accessible, and educational pronoun resource on the internet. Not just a list of pronouns, but a platform that actually teaches people how to use them correctly in real conversations. Plus, I wanted to build something that could serve as embeddable content for Discord bots and other applications where quick pronoun references are needed.

What started as a simple static site idea quickly evolved into a full Next.js application with TypeScript, animations, and community features. Sometimes the best projects are the ones that grow beyond their original scope because you realize you're solving a problem that actually matters.

---

# The Technical Foundation: Why Next.js?

From the start, I knew this project needed more than a simple static site generator. As I mapped out the features I wanted - dynamic routing for individual pronoun pages, interactive components for examples, and eventually community features - Next.js felt like the natural choice.

## Starting with the Data Structure

Before touching any UI code, I needed to nail down how to structure pronoun information. After researching various pronoun sets and educational resources, I settled on this TypeScript structure:

```typescript
export type PronounSet = {
  slug: string
  title: string
  subject: string
  object: string
  possessiveAdj: string
  possessivePro: string
  reflexive: string
  description: string
  examples: string[]
  source?: string
}
```

This covers all the grammatical forms people actually need to know, plus practical examples for each. The `examples` array was crucial - most pronoun resources just show the grammatical forms, but people learn better with real sentence examples.

---

# Building the User Experience

The biggest challenge wasn't technical - it was educational. How do you teach pronoun usage without overwhelming people or making it feel like a grammar lesson?

I decided on a card-based layout where each pronoun set gets its own "floating card" with a clean, approachable design. Users can browse the overview page to see all available pronouns, then click through to dedicated pages for detailed examples and usage notes.

## The FloatingCard Component

I spent way too much time perfecting this component, but it was worth it. The cards use a glassmorphism effect with subtle animations powered by Framer Motion:

```typescript
<motion.div
  className="floating-card"
  whileHover={{ y: -2, scale: 1.02 }}
  transition={{ duration: 0.2 }}
>
  {/* Content */}
</motion.div>
```

The hover animations give immediate feedback, and the glassmorphism effect (backdrop blur with translucent backgrounds) creates a modern, approachable feel that doesn't intimidate users who might be nervous about learning new concepts.

## Dark/Light Theme System

Accessibility was a huge priority, so I implemented a comprehensive theme system using CSS custom properties and React Context. The theme switcher automatically detects system preferences but lets users override manually.

What I'm particularly proud of is how the gradient backgrounds adapt to each theme - the light theme uses soft, warm gradients while the dark theme shifts to cooler, more subdued tones. It's a small detail, but it makes the experience feel polished.

---

# The Challenge of Comprehensive Coverage

One thing that surprised me during development was just how many different pronoun sets exist. I started with the "standard" ones (she/her, he/him, they/them) but quickly realized I needed to cover:

- **Mixed pronouns** like she/him or they/her
- **Neopronouns** like xe/xem, ze/hir, ze/zir
- **Special cases** like name pronouns and "any pronouns"

Each set required careful research to ensure accurate descriptions and appropriate examples. I didn't want to just list pronouns - I wanted to explain why they exist and how they fit into the broader conversation about inclusive language.

The hardest part was writing examples that felt natural without being overly prescriptive. I wanted sentences that people could actually imagine using in real conversations, not academic examples that sound stilted.

## Dynamic Routing Magic

Next.js's App Router made creating individual pages for each pronoun set incredibly straightforward. The `[pronoun]/page.tsx` file automatically generates routes for every pronoun in my data array:

```typescript
export async function generateStaticParams() {
  return pronouns.map((pronoun) => ({
    pronoun: pronoun.slug,
  }))
}
```

This means adding a new pronoun set is as simple as adding it to the data array - the routing, page generation, and navigation all update automatically.

---

# Adding Community Features

After the initial launch, I realized the site needed a way for the community to provide feedback and suggest improvements. Static content is great, but language evolves, and I wanted the site to evolve with it.

I discovered **Giscus**, which turns GitHub Discussions into a comment system. This was perfect because:
- It keeps all feedback in one place (GitHub)
- Users can suggest new pronoun sets or report inaccuracies
- The moderation is handled through GitHub's existing tools
- It maintains the open-source spirit of the project

## Implementation Challenges

Getting Giscus to work with Next.js and match the site's design took some finessing. The component needs to:
- Respect the current theme (dark/light)
- Load only when needed to avoid affecting page performance
- Match the site's visual design language

```typescript
<Giscus
  repo="nobleskye/pronouns.site"
  repoId="..."
  category="General"
  categoryId="..."
  mapping="pathname"
  theme={theme === 'dark' ? 'dark' : 'light'}
  reactionsEnabled="1"
  emitMetadata="0"
  inputPosition="top"
  lang="en"
/>
```

The theme switching was particularly tricky since Giscus loads in an iframe, but I managed to sync it with the main site's theme system.

---

# Performance and Deployment Strategy

One thing I learned from previous projects is that educational content needs to be fast and accessible. Nobody wants to wait for a website to load when they're trying to quickly check how to use someone's pronouns correctly.

## Build Optimizations

```json
{
  "scripts": {
    "build": "next build",
    "pages:build": "npx @cloudflare/next-on-pages",
    "pages:deploy": "npx wrangler pages deploy .vercel/output/static"
  }
}
```

The static generation ensures every pronoun page loads instantly. Since the content doesn't change frequently, this approach gives us the best of both worlds - dynamic capabilities during development with static performance in production.

---

# What I Learned About Inclusive Design

Building pronouns.site taught me a lot about designing for diverse audiences. Some key insights:

**Clarity over cleverness**: The most important thing is making information easy to find and understand. Fancy animations are nice, but clear typography and logical navigation matter more.

**Examples are everything**: People don't learn pronouns from grammatical charts - they learn from seeing them used naturally in sentences. The examples section became the most important part of each page.

**Community input is valuable**: Since adding the feedback system, I've received several suggestions for new pronoun sets and corrections to existing descriptions. The community knows their needs better than I do.

---

# Technical Stack Deep Dive

For anyone interested in the implementation details:

**Frontend**: Next.js 14 with TypeScript for type safety and modern React features
**Styling**: Tailwind CSS with custom design tokens and glassmorphism effects  
**UI Components**: Radix UI primitives for accessibility-first component design
**Animation**: Framer Motion for smooth, performant animations
**Comments**: Giscus (GitHub Discussions) for community feedback on pages and suggestions that sync with the GitHub repo
**Monitoring**: Vercel Analytics and GitHub insights

The entire project is open source and available on GitHub.

---

## What's Next

I'm considering several improvements based on community feedback:
- **Audio pronunciation guides** for unfamiliar pronoun sets
- **Interactive practice exercises** where users can try using different pronouns in example sentences
- **Multi-language support** starting with Spanish and French
- **Search functionality** for quickly finding specific information
- **Better mobile experience** with gesture-based navigation
- **More educational resources** on the history and importance of pronouns in language

---

# Getting Started

If you want to explore the site, head over to [pronouns.site](https://pronouns.site) to browse the full collection of pronoun sets. If you're a developer interested in the technical implementation, the complete source code is available on [GitHub](https://github.com/nobleskye/pronouns.site).

And if you have suggestions for improvements or new pronoun sets to add, the community feedback system is built right into the site. Sometimes the best projects are the ones that grow and improve with their community.

🏳️‍⚧️💙
