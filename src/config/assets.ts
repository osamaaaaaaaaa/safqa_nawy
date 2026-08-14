import heroImage from '../assets/hero.png'
import findstateHeroImage from '../assets/findstate-hero.jpg'
import propertyOneImage from '../assets/property-1.jpg'
import propertyTwoImage from '../assets/property-2.jpg'
import propertyThreeImage from '../assets/property-3.jpg'
import propertyFourImage from '../assets/property-4.jpg'
import propertyFiveImage from '../assets/property-5.jpg'
import propertySixImage from '../assets/property-6.jpg'
import aboutImage from '../assets/about.jpg'
import listingOneImage from '../assets/listing-1.jpg'
import listingTwoImage from '../assets/listing-2.jpg'
import listingThreeImage from '../assets/listing-3.jpg'
import listingFourImage from '../assets/listing-4.jpg'
import listingFiveImage from '../assets/listing-5.jpg'
import listingSixImage from '../assets/listing-6.jpg'
import teamOneImage from '../assets/team-1.jpg'
import teamTwoImage from '../assets/team-2.jpg'
import teamThreeImage from '../assets/team-3.jpg'
import teamFourImage from '../assets/team-4.jpg'
import personOneImage from '../assets/person-1.jpg'
import personTwoImage from '../assets/person-2.jpg'
import personThreeImage from '../assets/person-3.jpg'
import blogOneImage from '../assets/blog-1.jpg'
import blogTwoImage from '../assets/blog-2.jpg'
import blogThreeImage from '../assets/blog-3.jpg'
import blogFourImage from '../assets/blog-4.jpg'

export const assetKeys = {
  hero: 'landing.hero.transferDesk',
  findstateHero: 'landing.hero.findstate',
  propertyOne: 'landing.properties.one',
  propertyTwo: 'landing.properties.two',
  propertyThree: 'landing.properties.three',
  propertyFour: 'landing.properties.four',
  propertyFive: 'landing.properties.five',
  propertySix: 'landing.properties.six',
  about: 'landing.about',
  listingOne: 'landing.listings.one',
  listingTwo: 'landing.listings.two',
  listingThree: 'landing.listings.three',
  listingFour: 'landing.listings.four',
  listingFive: 'landing.listings.five',
  listingSix: 'landing.listings.six',
  teamOne: 'landing.team.one',
  teamTwo: 'landing.team.two',
  teamThree: 'landing.team.three',
  teamFour: 'landing.team.four',
  personOne: 'landing.people.one',
  personTwo: 'landing.people.two',
  personThree: 'landing.people.three',
  blogOne: 'landing.blog.one',
  blogTwo: 'landing.blog.two',
  blogThree: 'landing.blog.three',
  blogFour: 'landing.blog.four',
} as const

export const assets = {
  [assetKeys.hero]: {
    src: heroImage,
    altKey: 'assets.heroAlt',
  },
  [assetKeys.findstateHero]: {
    src: findstateHeroImage,
    altKey: 'assets.heroAlt',
  },
  [assetKeys.propertyOne]: {
    src: propertyOneImage,
    altKey: 'assets.propertyAlt',
  },
  [assetKeys.propertyTwo]: {
    src: propertyTwoImage,
    altKey: 'assets.propertyAlt',
  },
  [assetKeys.propertyThree]: {
    src: propertyThreeImage,
    altKey: 'assets.propertyAlt',
  },
  [assetKeys.propertyFour]: { src: propertyFourImage, altKey: 'assets.propertyAlt' },
  [assetKeys.propertyFive]: { src: propertyFiveImage, altKey: 'assets.propertyAlt' },
  [assetKeys.propertySix]: { src: propertySixImage, altKey: 'assets.propertyAlt' },
  [assetKeys.about]: { src: aboutImage, altKey: 'assets.aboutAlt' },
  [assetKeys.listingOne]: { src: listingOneImage, altKey: 'assets.listingAlt' },
  [assetKeys.listingTwo]: { src: listingTwoImage, altKey: 'assets.listingAlt' },
  [assetKeys.listingThree]: { src: listingThreeImage, altKey: 'assets.listingAlt' },
  [assetKeys.listingFour]: { src: listingFourImage, altKey: 'assets.listingAlt' },
  [assetKeys.listingFive]: { src: listingFiveImage, altKey: 'assets.listingAlt' },
  [assetKeys.listingSix]: { src: listingSixImage, altKey: 'assets.listingAlt' },
  [assetKeys.teamOne]: { src: teamOneImage, altKey: 'assets.teamAlt' },
  [assetKeys.teamTwo]: { src: teamTwoImage, altKey: 'assets.teamAlt' },
  [assetKeys.teamThree]: { src: teamThreeImage, altKey: 'assets.teamAlt' },
  [assetKeys.teamFour]: { src: teamFourImage, altKey: 'assets.teamAlt' },
  [assetKeys.personOne]: { src: personOneImage, altKey: 'assets.personAlt' },
  [assetKeys.personTwo]: { src: personTwoImage, altKey: 'assets.personAlt' },
  [assetKeys.personThree]: { src: personThreeImage, altKey: 'assets.personAlt' },
  [assetKeys.blogOne]: { src: blogOneImage, altKey: 'assets.blogAlt' },
  [assetKeys.blogTwo]: { src: blogTwoImage, altKey: 'assets.blogAlt' },
  [assetKeys.blogThree]: { src: blogThreeImage, altKey: 'assets.blogAlt' },
  [assetKeys.blogFour]: { src: blogFourImage, altKey: 'assets.blogAlt' },
} as const
