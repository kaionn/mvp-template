export default function HomePage() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-8">
      <h1 className="text-4xl font-bold">Hello, {"{{PRODUCT_NAME}}"}</h1>
      <p className="mt-4 text-gray-600">
        このページは mvp-template の最小 boilerplate です。docs/spec.md に従って実装してください。
      </p>
    </main>
  );
}
