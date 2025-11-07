export const metadata = {
  title: 'CloudNorth Platform',
  description: 'Modern cloud application platform',
}

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        <nav style={{ padding: '1rem', borderBottom: '1px solid #ccc' }}>
          <h1>CloudNorth Platform</h1>
        </nav>
        {children}
      </body>
    </html>
  )
}
